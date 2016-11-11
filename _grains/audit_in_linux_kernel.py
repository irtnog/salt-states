# -*- coding: utf-8 -*-
from __future__ import absolute_import
import logging
import sys

log = logging.getLogger(__name__)

HAS_NETLINK = False
if sys.platform == 'linux2':
    try:
        from socket import socket, AF_NETLINK, SOCK_RAW
        HAS_NETLINK = True
    except ImportError:
        log.exception('Unable to import Python socket module; the audit_in_linux_kernel grain will be missing.')


def audit_in_linux_kernel():
    '''
    Determine whether the Linux kernel includes audit support.
    '''
    if not HAS_NETLINK:
        return {}

    grains = {}
    try:
        fd = socket(AF_NETLINK, SOCK_RAW, 9)
        grains['audit_in_linux_kernel'] = True
    except:
        grains['audit_in_linux_kernel'] = False
    if grains['audit_in_linux_kernel']:
        fd.close()
    return grains
