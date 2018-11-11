#### HOSTNAME/INIT.SLS --- Change the computer's hostname to match the minion ID

{%- set fqdn = salt['grains.get']('id') %}
{%- set hostname = fqdn.split('.')[0] %}

{%- if salt['grains.get']('host').lower() != hostname.lower() %}
{%-   if (salt['grains.get']('os_family') == 'RedHat' and salt['grains.get']('osmajorrelease') >= 7)
      or (salt['grains.get']('os_family') == 'Debian' and salt['grains.get']('osmajorrelease') >= 9) %}

set_hostname:
  file.managed:
    - name: /etc/hostname
    - contents: {{
        fqdn|yaml_encode if salt['grains.get']('os_family') == 'RedHat' else
        hostname|yaml_encode
      }}

  cmd.run:
    - name:
        hostnamectl set-hostname $(cat /etc/hostname)
        && systemctl restart systemd-hostnamed
    - onchanges:
        - file: set_hostname

{%-   elif salt['grains.get']('os_family') == 'Windows' %}

set_hostname:
  system.computer_name:
    - name: {{ hostname|yaml_encode }}

{%-     set netdom = salt['pillar.get']('netdom', {}) %}
{%-     if 'join' in netdom
        and netdom['join'] is mapping
        and netdom['join'] %}
{%-       set params = netdom['join'] %}

join_domain:
  system.join_domain:
    - name: {{ params['domain']|yaml_encode }}
    - username: {{ params['user']|yaml_encode }}
    - password: {{ params['password']|yaml_encode }}
    - account_ou: {{ params['ou']|join(',')|yaml_encode }}
    - account_exists: True
    - onchanges_in:
        - system: reboot_apply_changes

{%-     endif %}

reboot_apply_changes:
  system.reboot:
    - onchanges:
        - system: set_hostname

{%-   endif %}

{%-   if salt['grains.get']('biosversion').find('amazon') > -1 %}

## Prevent cloud-init from overriding the hostname set above.
/etc/cloud/cloud.cfg.d/99_hostname.cfg:
  file.managed:
    - contents: |
        hostname: {{ hostname }}
        fqdn: {{ fqdn }}

{%-   endif %}
{%- endif %}

#### HOSTNAME/INIT.SLS ends here.
