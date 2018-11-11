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
