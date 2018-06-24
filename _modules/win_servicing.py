'''
A wrapper for DISM, the Windows Deployment Image Servicing and
Management tool.
'''
from __future__ import absolute_import

## Import Python libraries
import distutils.spawn
import logging
import re

## Import Salt libraries
import salt.exceptions
import salt.log

log = logging.getLogger(__name__)

dism_cmd = distutils.spawn.find_executable('dism.exe')

def __virtual__():
    return 'win_servicing' if dism_cmd else False

def _dism(action,
          image=None):
    '''
    Run a DISM servicing command on the given image.
    '''
    command='{0} {1} {2}'.format(
        dism_cmd,
        '/Image:{0}'.format(image) if image else '/Online',
        action
    )
    ret = {'action': action,
           'image': image,
           'result': True,
           'message': ''}
    output = __salt__['cmd.run'](command, ignore_retcode=True)
    if not re.search('The operation completed successfully.', output):
        ret['result'] = False
        ret['message'] = re.search(
            '(Error: \d+\r?\n\r?\n([^\r\n]+\r?\n)+\r?\nThe DISM log file can be found at [^\r\n]\r?\n)',
            output,
            re.MULTILINE
        ).group(1)
        log.exception('DISM command \'{0}\' on image {1} failed: {2}'.format(action, image, ret['message']))
    else:
        ret['message'] = output
        log.debug('DISM command \'{0}\' on image {1} completed with the following output: {2}'.format(action, image, output))
    return ret

def get_packages(image=None):
    '''
    Return information about all packages in the image (relative to
    the minion on which this command is run).  If no image is
    specified, this will target the minion itself.

    CLI Example:

    .. code-block:: bash

        salt -G os:Windows win_servicing.get_packages
    '''
    dism = _dism('/Get-Packages', image)
    if not dism['result']:
        return {}

    return {p: {'State': s, 'Release Type': r, 'Install Time': t}
            for p, s, r, t
            in re.findall('Package Identity : ([^\r\n]+)\r?\nState : ([^\r\n]+)\r?\nRelease Type : ([^\r\n]+)\r?\nInstall Time : ([^\r?\n]+)\r?\n',
                          dism['message'], re.MULTILINE)}

def get_features(image=None,
                 package=None):
    '''
    Return information about all features found in a specific package
    within a specific image.  If you do not specify a package name or
    path, all features in the image will be listed.  If you do not
    specify an image, this will target the minion itself.

    CLI Example:

    .. code-block:: bash

        salt -G os:Windows win_servicing.get_features
    '''
    dism = _dism(
        '/Get-Features {0}'.format(
            '/PackageName:{0}'.format(package) if package else ''
        ),
        image)
    if not dism['result']:
        return {}

    return {f: {'State': s}
            for f, s
            in re.findall('Feature Name : ([^\r\n]+)\r?\nState : ([^\r\n]+)\r?\n',
                          dism['message'], re.MULTILINE)}

def enable_feature(name,
                   image=None,
                   package=None,
                   sources=[]):
    '''
    Enable the specified Windows feature.

    name
        The name of the feature (case-sensitive).

        CLI Example:

        .. code-block:: bash

            salt -G osrelease:2008ServerR2 win_servicing.enable_feature TelnetClient

    image
        Enable the feature in the specified offline image.  If no
        image is specified, the feature will be enabled in the running
        Windows installation.  Note that the path to the offline image
        is relative to the minion, not the master.

        CLI Example:

        .. code-block:: bash

            salt-call win_servicing.enable_feature TelnetClient image='C:\test\offline'

    package
        Enable the feature from the specified package.  If no package
        name is specified, the Windows Foundation package is assumed.

        CLI Example:

        .. code-block:: bash

            salt -G osrelease:2008ServerR2 win_servicing.enable_feature Calc package=Microsoft.Windows.Calc.Demo~6595b6144ccf1df~x86~en~1.0.0.0

    sources
        Specify a list of one or more sources to search for the
        required files needed to enable the feature.  If you do not
        specify a source, this will look in the default location
        specified by Group Policy
        (https://technet.microsoft.com/en-us/library/hh825020.aspx).

        CLI Example:

        .. code-block:: bash

            salt-call win_servicing.enable_feature TelnetClient sources="['d:\sources\sxs']"
    '''
    ret = {'name': name,
           'result': True,
           'changes': {},
           'comment': ''}
    features = get_features(image, package)
    if name not in features:
        ret['result'] = False
        ret['comment'] = 'Feature {0} not found'.format(name)
        return ret
    elif features[name]['State'] == 'Enabled':
        ret['comment'] = 'Feature {0} already installed'.format(name)
        return ret
    elif features[name]['State'] == 'Enable Pending':
        ret['pending'] = True
        ret['comment'] = 'Feature {0} already installed (pending a reboot)'.format(name)
        return ret

    dism = _dism('/Enable-Feature /FeatureName:{0} {1} {2} /NoRestart'.format(
        name,
        '/PackageName:{0}'.format(package) if package else '',
        ' '.join(['/Source:{0}'.format(source) for source in sources])),
                   image)
    if not dism['result']:
        ret['result'] = False
        ret['comment'] = 'Feature {0} installation failed'.format(name)
        ret['message'] = dism['message']
        return ret

    ret['changes'] = {'win_servicing': 'Installed feature {0}'.format(name)}
    features = get_features(image, package)
    if features[name]['State'] == 'Enable Pending':
        ret['pending'] = True
        ret['comment'] = 'Reboot to complete feature {0} installation'.format(name)
    return ret

def disable_feature(name,
                    image=None,
                    keep_manifest=False):
    '''
    Disable the specified Windows feature.

    name
        The name of the feature (case-sensitive).

        CLI Example:

        .. code-block:: bash

            salt -G osrelease:2008ServerR2 win_servicing.disable_feature TelnetClient

    image
        Disable the feature in the specified offline image.  If no
        image is specified, the feature will be disabled in the
        running Windows installation.  Note that the path to the
        offline image is relative to the minion, not the master.

        CLI Example:

        .. code-block:: bash

            salt-call win_servicing.disable_feature TelnetClient image='C:\test\offline'

    keep_manifest
        If set, remove the feature in the image without also removing
        its manifest (only Windows 8/Windows Server 2012 and newer).

        CLI Example:

        .. code-block:: bash

            salt-call win_servicing.disable_feature TelnetClient keep_manifest=True
    '''
    ret = {'name': name,
           'result': True,
           'changes': {},
           'comment': ''}
    features = get_features(image)
    if name not in features:
        ret['result'] = False
        ret['comment'] = 'Feature {0} not found'.format(name)
        return ret
    elif features[name]['State'] == 'Disabled':
        ret['comment'] = 'Feature {0} already removed'.format(name)
        return ret
    elif features[name]['State'] == 'Disable Pending':
        ret['pending'] = True
        ret['comment'] = 'Feature {0} already removed (pending a reboot)'.format(name)
        return ret

    dism = _dism('/Disable-Feature /FeatureName:{0} /NoRestart'.format(name), image)
    if not dism['result']:
        ret['result'] = False
        ret['comment'] = 'Feature {0} removal failed'.format(name)
        ret['message'] = dism['message']
        return ret

    ret['changes'] = {'win_servicing': 'Removed feature {0}'.format(name)}
    features = get_features(image)
    if features[name]['State'] == 'Disable Pending':
        ret['pending'] = True
        ret['comment'] = 'Reboot to complete feature {0} removal'.format(name)
    return ret
