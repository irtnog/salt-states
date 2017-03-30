#### HOSTNAME/INIT.SLS --- Change the computer's hostname to match the minion ID

{%- set fqdn = grains.id %}
{%- set hostname = fqdn.split('.')[0] %}

{%- if grains.host.lower() != hostname.lower() %}
{%-   if grains.os_family == 'RedHat'
         and grains.osmajorrelease >= 7 %}

set_hostname:
  file.managed:
    - name: /etc/hostname
    - contents: {{ fqdn|yaml_encode }}

  cmd.run:
    - name:
        hostnamectl set-hostname $(cat /etc/hostname)
        && systemctl restart systemd-hostnamed
    - onchanges:
        - file: set_hostname

{%-   elif grains.os_family == 'Windows' %}

set_hostname:
  cmd.run:
    - name: rename-computer {{ hostname }}; shutdown /r
    - shell: powershell

{%-   endif %}
{%- endif %}

{%- if grains.biosversion.find('amazon') > -1 %}

## Prevent cloud-init from overriding the hostname set above.
/etc/cloud/cloud.cfg.d/99_hostname.cfg:
  file.managed:
    - contents: |
        hostname: {{ hostname }}
        fqdn: {{ fqdn }}

{%- endif %}

#### HOSTNAME/INIT.SLS ends here.
