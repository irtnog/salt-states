# keep lint from choking on _get_conn and _cache_id
#pylint: disable=E0602,W0106

# Import Python libs
from __future__ import absolute_import
import logging
import time

# Import Salt libs
import salt.utils.boto3
import salt.utils.compat
from salt.exceptions import SaltInvocationError
log = logging.getLogger(__name__)  # pylint: disable=W1699

# Import third party libs
try:
    #pylint: disable=unused-import
    import boto3
    #pylint: enable=unused-import
    from botocore.exceptions import ClientError
    logging.getLogger('boto3').setLevel(logging.CRITICAL)
    HAS_BOTO3 = True
except ImportError:
    HAS_BOTO3 = False


def __virtual__():
    '''
    Only load if boto libraries exist and if boto libraries are
    greater than a given version.
    '''
    if not HAS_BOTO3:
        return (False, 'The irtnog_ec2 module could not be loaded: '
                'boto3 libraries not found')
    return True


def __init__(opts):
    salt.utils.compat.pack_dunder(__name__)
    if HAS_BOTO3:
        __utils__['boto3.assign_funcs'](__name__, 'ec2')


def find_images(region=None, key=None, keyid=None, profile=None, return_objs=False,
                ExecutableUsers=[], Filters=[], ImageIds=[], Owners=[],
                **kwargs):
    conn = _get_conn(region=region, key=key, keyid=keyid, profile=profile)
    resp = conn.describe_images(ExecutableUsers=ExecutableUsers, Filters=Filters,
                                ImageIds=ImageIds, Owners=Owners)
    log.debug('The search criteria matched the following images: '
              '{0}.'.format(resp))
    if return_objs:
        return resp['Images']
    return [image['ImageId'] for image in resp['Images']]


def find_latest_image(region=None, key=None, keyid=None, profile=None, return_obj=False,
                      ExecutableUsers=[], Filters=[], ImageIds=[], Owners=[],
                      **kwargs):
    images = find_images(region=region, key=key, keyid=keyid, profile=profile,
                         return_objs=True, ExecutableUsers=ExecutableUsers,
                         Filters=Filters, ImageIds=ImageIds, Owners=Owners)
    if images:
        images.sort(reverse=True, key=lambda image: image['CreationDate'])
        image = images[0]
        log.debug('Image {0} has a creation date of '
                  '{1}.'.format(image['ImageId'], image['CreationDate']))
        if return_obj:
            return image
        return image['ImageId']
    return False
