# Import Python libs
from __future__ import absolute_import, print_function, unicode_literals
import logging

# Import Salt libs
import salt.utils.versions

log = logging.getLogger(__name__)

# Import third party libs
#pylint: disable=unused-import
try:
    import botocore
    import boto3
    import jmespath
    logging.getLogger('boto3').setLevel(logging.CRITICAL)
    HAS_BOTO = True
except ImportError:
    HAS_BOTO = False
#pylint: enable=unused-import


def __virtual__():
    '''
    Only load if boto libraries exist.
    '''
    has_boto_reqs = salt.utils.versions.check_boto_reqs()
    if has_boto_reqs is True:
        __ utils__['boto3.assign_funcs'](__name__, 'ec2')
    return has_boto_reqs


def find_images(region=None, key=None, keyid=None, profile=None, return_objs=False, **kwargs):
    conn = _get_conn(region=region, key=key, keyid=keyid, profile=profile)
    resp = conn.describe_images(**kwargs)
    log.debug('The filters criteria {0} matched the following '
              'images: {1}.'.format(kwargs, resp))
    if return_objs:
        return resp['Images']
    return [image.id for image in resp['Images']]


def find_latest_image(region=None, key=None, keyid=None, profile=None, return_obj=False, **kwargs):
    images = find_images(region=region, key=key, keyid=keyid, profile=profile, return_objs=True, **kwargs)
    if images:
        images.sort(reverse=True, key=lambda image: image.creation_date)
        image = images[0]
        log.debug('This identified {0} with a creation date of {1} '
                  'as the latest image matching the filter criteria '
                  '{2}.'.format(image.id, image.creation_date, kwargs))
        if return_obj:
            return image
        return image.id
    return False
