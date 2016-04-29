# requires PowerShell 3.0
start_server_manager_performance_monitor:
  cmd.run:
    - names:
        {% if salt['grains.get']('osrelease') in ['2012Server', '2012ServerR2'] %}
        - 'schtasks /Change /TN "\Microsoft\Windows\PLA\Server Manager Performance Monitor" /ENABLE'
        {% endif %}
        - 'logman start "Server Manager Performance Monitor"'
