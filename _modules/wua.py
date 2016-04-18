## Import Python libraries
from __future__ import absolute_import
import logging

## Import Salt libraries
import salt.log

## Import third-party libraries
try:
    import win32com.client
    wua = win32com.client.Dispatch("Microsoft.Update.ServiceManager")
    HAS_DEPENDENCIES = True
except ImportError:
    HAS_DEPENDENCIES = False

log = logging.getLogger(__name__)

def __virtual__():
    if __grains__['kernel'] == 'Windows' and HAS_DEPENDENCIES:
        return 'wua_updateservicemanager'
    else:
        return False

def _services():
    return [{'CanRegisterWithAU': wua.Services.Item(i).CanRegisterWithAU,
             'ContentValidationCert': format(wua.Services.Item(i).ContentValidationCert) if len(wua.Services.Item(i).ContentValidationCert) != 0 else None,
             'ExpirationDate': wua.Services.Item(i).ExpirationDate if len(wua.Services.Item(i).ContentValidationCert) != 0 else None,
             'IsManaged': wua.Services.Item(i).IsManaged,
             'IsRegisteredWithAU': wua.Services.Item(i).IsRegisteredWithAU,
             'IsScanPackageService': wua.Services.Item(i).IsScanPackageService,
             'IssueDate': wua.Services.Item(i).IssueDate if len(wua.Services.Item(i).ContentValidationCert) != 0 else None,
             'Name': wua.Services.Item(i).Name,
             'OffersWindowsUpdates': wua.Services.Item(i).OffersWindowsUpdates,
             'RedirectUrls': [wua.Services.Item(i).RedirectUrls.Item(j) for j in range(wua.Services.Item(i).RedirectUrls.Count)],
             'ServiceID': wua.Services.Item(i).ServiceID,
             'ServiceUrl': wua.Services.Item(i).ServiceUrl,
             'SetupPrefix': wua.Services.Item(i).SetupPrefix} for i in range(wua.Services.Count)]

def _addservice(service_id, authz_cab_path):
    wua = win32com.client.Dispatch("Microsoft.Update.ServiceManager")
    return wua.AddService(service_id, authz_cab_path)
