#### HOSTNAME/INIT.SLS --- Change the computer's hostname to match the minion ID

{% set fqdn = salt['grains.get']('id') %}
{% set hostname = fqdn.split('.')[0] %}

{% if salt['grains.get']('os_family') == 'RedHat' %}
  {% if salt['grains.get']('osmajorrelease') >= 7 %}
set_hostname:
  file.managed:
    - name: /etc/hostname
    - contents: {{ fqdn }}
  cmd.wait:
    - name: hostnamectl set-hostname {{ fqdn }} && systemctl restart systemd-hostnamed
    - watch:
        - file: set_hostname
  service.running:
    - name: systemd-hostnamed
    - enable: True
    - watch:
        - file: set_hostname
        - cmd: set_hostname

    {% if salt['grains.get']('biosversion').find('amazon') > -1 %}
## prevent cloud-init from overriding the hostname set above
/etc/cloud/cloud.cfg.d/99_hostname.cfg:
  file.managed:
    - contents: |
        hostname: {{ hostname }}
        fqdn: {{ fqdn }}
    {% endif %}
  {% endif %}
{% endif %}

#### HOSTNAME/INIT.SLS ends here.
