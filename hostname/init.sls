#### HOSTNAME/INIT.SLS --- Change the computer's hostname to match the minion ID

{% set fqdn = grains.id %}
{% set hostname = fqdn.split('.')[0] %}

{% if grains.os_family == 'RedHat' %}
  {% if grains.osmajorrelease >= 7 %}
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
  {% endif %}
{% endif %}

{% if grains.biosversion.find('amazon') > -1 %}
## prevent cloud-init from overriding the hostname set above
/etc/cloud/cloud.cfg.d/99_hostname.cfg:
  file.managed:
    - contents: |
        hostname: {{ hostname }}
        fqdn: {{ fqdn }}
{% endif %}

#### HOSTNAME/INIT.SLS ends here.
