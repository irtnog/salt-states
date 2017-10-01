#### SALT/MODULES/IRTNOG_UTILS.PY --- Miscellaneous, supplemental utility functions

from __future__ import absolute_import

import salt.utils
import logging

log = logging.getLogger(__name__)

def __virtual__():
    return 'irtnog_utils'

def get_default_vpc_id(region=None, key=None, keyid=None, profile=None, **kwargs):
    '''
    Return the default VPC for the specified region.
    '''
    return [vpc for vpc in __salt__['boto_vpc.describe_vpcs'](
        region=region, key=key, keyid=keyid, profile=profile)['vpcs']
            if vpc['is_default']][0]['id']

#### SALT/MODULES/IRTNOG_UTILS.PY ends here.
