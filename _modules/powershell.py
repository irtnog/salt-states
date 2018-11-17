from __future__ import absolute_import
import logging

log = logging.getLogger(__name__)

def __virtual__():
    if __grains__['os_family'] != 'Windows':
        return False
    return 'powershell'

def test(name, **kwargs):
    return True
