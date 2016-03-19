## Fixes `PXE-E32: TFTP open timeout` errors caused by WDSServer
## allocating high UDP ports without checking whether another process
## is already using them, e.g., DNSServer.
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\WDSServer\Parameters\UdpPortPolicy:
  reg.present:
    - vtype: REG_DWORD
    - value: 0
