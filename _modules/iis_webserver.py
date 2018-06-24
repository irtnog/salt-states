'''
A thin wrapper around the IIS PowerShell cmdlets.
'''
from __future__ import absolute_import

## Import Python libraries
import json
import logging
import inspect
import sys

## Import Salt libraries
import salt.log

log = logging.getLogger(__name__)

def __virtual__():
    ## This only works on Windows Server 2008 and newer.
    if __grains__['os_family'] != 'Windows' or \
       int(__grains__['osversion'].split('.')[0]) < 6:
        return False

    ## TODO: Check for the WebAdministration module.

    ## Get the list of available cmdlets at runtime.
    cmdlets = _pswrapper('Get-Help -Category cmdlet | Where-Object { '
                         '($_.ModuleName -eq \'WebAdministration\'} | '
                         'Select Name, Synopsis | Sort Name')

    ## This generates Python functions for each of the
    ## WebAdministration cmdlets listed above.
    this_module = sys.modules[__name__]
    for cmdlet in cmdlets:
        def f(x):
            def g(**kwargs):
                return _pswrapper(x, **kwargs)
            return g
        c_name = cmdlet['Name']
        c_docs = cmdlet['Synopsis']
        f_name = c_name.replace('-', '_').lower()
        setattr(this_module, f_name, f(c_name))
        getattr(this_module, f_name).__doc__ = c_docs

    return 'iis_webserver'

def _pscredential(username, password):
    '''
    Generate code that converts a username and a password into a
    PSCredential object.
    '''
    return 'New-Object -TypeName System.Management.Automation.PSCredential ' \
        '-ArgumentList "'+username+'", ' \
        '(ConvertTo-SecureString -String "'+password+'" -AsPlainText -Force)'

def _pswrapper(cmdlet, **kwargs):
    '''
    Wrap calls to PowerShell cmdlets.

    The results of the cmdlet, if successful, are serialized into a
    JSON document by PowerShell and deserialized into the appropriate
    Python object by Salt.
    '''
    cmd = [cmdlet]

    ## Loop through kwargs, which get translated verbatim into cmdlet
    ## parameters.
    for k, v in kwargs.items():
        if k.find('__pub') >= 0:
            ## filter out special kwargs like '/__pub_fun'
            pass
        elif v == True or v == False:
            cmd.append('-{0}:${1}'.format(k, v))
        elif type(v) is dict and 'username' in v:
            ## assume dicts that contain a 'username' key should get
            ## transformed into PSCredential objects
            cmd.append('-{0} ({1})'.format(k, _pscredential(v.username, v.password)))
        elif type(v) is int:
            cmd.append('-{0} {1}'.format(k, v))
        else:
            ## FIXME: PowerShell string escaping
            cmd.append('-{0} "{1}"'.format(k, v))
    cmd.append('| ConvertTo-Json -Compress -Depth 32')

    response = __salt__['cmd.powershell'](' '.join(cmd))
    ## TODO: check the response for errors
    return json.loads(response)
