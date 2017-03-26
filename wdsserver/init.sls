## Fixes `PXE-E32: TFTP open timeout` errors caused by WDSServer
## allocating high UDP ports without checking whether another process
## is already using them, e.g., DNSServer.
wds_tftp_open_timeout_fix:
  reg.present:
    - name: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\WDSServer\Parameters
    - vname: UdpPortPolicy
    - vtype: REG_DWORD
    - vdata: 0
