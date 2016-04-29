# requires PowerShell 3.0
start_server_manager_performance_monitor:
  cmd.run:
    - names:
        - 'schtasks /Change /TN "\Microsoft\Windows\PLA\Server Manager Performance Monitor" /ENABLE'
        - 'logman start "Server Manager Performance Monitor"'
