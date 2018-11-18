from __future__ import absolute_import
import json
import logging

log = logging.getLogger(__name__)

try:
    import clr
    clr.AddReference('System.Management.Automation')
    from System.Management.Automation import PowerShell, RunspaceMode
    HAS_POWERSHELL = True
except:
    HAS_POWERSHELL = False

def __virtual__():
    if __grains__['os_family'] != 'Windows':
        return False
    if not HAS_POWERSHELL:
        return False
    return 'powershell'

def test(name, **kwargs):
    ps = PowerShell.Create(RunspaceMode.NewRunspace)
    ps.AddCommand('Get-Process').AddCommand('Select-Object').AddParameter('property', 'name').AddCommand('ConvertTo-JSON')
    ret = ps.Invoke()
    return [ process['Name'] for process in json.loads(ret[0].ToString()) ]
