{% if salt['grains.get']('os_family') == 'Windows' %}

powershell_update_help:
  cmd.run:
    - name: Update-Help
    - shell: powershell

{% endif %}
