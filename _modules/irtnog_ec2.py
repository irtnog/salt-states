# Import Python libs
from __future__ import absolute_import
import logging
import time
import json

# Import Salt libs
import salt.utils
import salt.utils.compat
import salt.ext.six as six
from salt.exceptions import SaltInvocationError, CommandExecutionError
from salt.utils.versions import LooseVersion as _LooseVersion

# Import third party libs
try:
    # pylint: disable=unused-import
    import boto
    import boto.ec2
    # pylint: enable=unused-import
    from boto.ec2.blockdevicemapping import BlockDeviceMapping, BlockDeviceType
    HAS_BOTO = True
except ImportError:
    HAS_BOTO = False

log = logging.getLogger(__name__)

def __virtual__():
    '''
    Only load if boto libraries exist and if boto libraries are greater than
    a given version.
    '''
    required_boto_version = '2.8.0'
    # the irtnog_ec2 execution module relies on the connect_to_region() method
    # which was added in boto 2.8.0
    # https://github.com/boto/boto/commit/33ac26b416fbb48a60602542b4ce15dcc7029f12
    if not HAS_BOTO:
        return (False, "The irtnog_ec2 module cannot be loaded: boto library not found")
    elif _LooseVersion(boto.__version__) < _LooseVersion(required_boto_version):
        return (False, "The irtnog_ec2 module cannot be loaded: boto library version incorrect ")
    else:
        __utils__['boto.assign_funcs'](__name__, 'ec2', pack=__salt__)
        return True

def find_images(filters={}, region=None, key=None, keyid=None, profile=None, return_objs=False):
    conn = _get_conn(region=region, key=key, keyid=keyid, profile=profile)
    try:
        images = conn.get_all_images(filters=filters)
        log.debug('The filters criteria {0} matched the following '
                  'images: {1}.'.format(filters, images))
        if images:
            if return_objs:
                return images
            return [image.id for image in images]
        else:
            return False
    except boto.exception.BotoServerError as e:
        log.error(e)
        return False

def find_latest_image(filters={}, region=None, key=None, keyid=None, profile=None, return_obj=False):
    images = find_images(filters=filters, region=region, key=key, keyid=keyid, profile=profile, return_objs=True)
    if images:
        images.sort(reverse=True, key=lambda image: image.creation_date)
        image = images[0]
        log.debug('This identified {0} with a creation date of {1} '
                  'as the latest image matching the filter criteria '
                  '{2}.'.format(image.id, image.creation_date, filters))
        if return_obj:
            return image
        return image.id
    return False
