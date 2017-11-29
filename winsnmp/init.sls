winsnmp:
  dism.feature_installed:
    - names:
        - SNMP                  # configuration handled by GPO
        - WMISnmpProvider

  service.running:
    - name: SNMP
    - enable: True
    - watch:
        - dism: winsnmp
