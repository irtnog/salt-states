{% from "nis/map.jinja" import nis_settings with context %}

{% for ypserver in nis_settings.ypservers %}
{% if not salt['dnsutil.check_ip'](ypserver) %}
ypbind_hosts_{{ ypserver }}:
  host.present:
    - name: {{ ypserver }}
    - ip: {{ salt['dnsutil.A'](ypserver)[0] }}
    {% if grains['os_family'] == 'RedHat' %}
    - require_in:
        - cmd: ypbind_authconfig
    {% endif %}
    - watch_in:
        - service: ypbind
{% endif %}
{% endfor %}

ypbind:
  pkg.installed:
    - pkgs: {{ nis_settings.client_packages|yaml }}
  {% if grains['os_family'] not in ['RedHat', 'Suse'] %}
  ## Suse's netconfig guesses the correct values.
  ## RedHat's authconfig overrides these settings.
  file.managed:
    - name: /etc/yp.conf
    - contents: |
      {%- for server in nis_settings.ypservers %}
        domain {{ nis_settings.ypdomain }} server {{ server }}
      {% else %}
        domain {{ nis_settings.ypdomain }} broadcast
      {%- endfor %}
    - user: root
    - group: 0
    - mode: 444
    - require:
        - pkg: ypbind
    - watch_in:
        - service: ypbind
  {% endif %}
  {% if grains['os_family'] == 'Debian' %}
  cmd.run:
    - name: systemctl enable rpcbind.service && systemctl start rpcbind
    - require:
        - pkg: ypbind
    - watch_in:
        - service: ypbind
  {% endif %}
  service.running:
    - names: {{ nis_settings.client_services|yaml }}
    - enable: True
    - watch:
        - pkg: ypbind

{% if grains['os_family'] in ['Debian', 'Suse'] %}

ypbind_passwd:
  cmd.script:
    - name: salt://nis/files/linux-enable-nis-passwd-map.sh

ypbind_group:
  file.append:
    - name: /etc/group
    - text: '+:*::'

{% elif grains['os_family'] == 'FreeBSD' %}
nisdomainname:
  sysrc.managed:
    - value: {{ nis_settings.ypdomain }}
    - watch_in:
        - service: ypbind

nisdomain:
  service.running:
    - watch:
      - sysrc: nisdomainname
    - watch_in:
      - service: ypbind

nis_client_flags:
  sysrc.managed:
    - value: "-m -S {{ nis_settings.ypdomain }}{%- for server in nis_settings.ypservers -%},{{ server }}{%- endfor -%}"
    - watch_in:
        - service: ypbind

ypbind_passwd:
  cmd.script:
    - name: salt://nis/files/freebsd-enable-nis-passwd-map.sh

ypbind_group:
  file.append:
    - name: /etc/group
    - text: '+:*::'

{% elif grains['os_family'] == 'RedHat' %}

ypbind_authconfig:
  file.replace:
    - name: /etc/sysconfig/authconfig
    - pattern: ^USENIS=no
    - repl: USENIS=yes
    - append_if_not_found: True
    - require:
        - pkg: ypbind
  cmd.run:
    - name: authconfig --update --enablenis --nisdomain={{ nis_settings.ypdomain }} {% if nis_settings.ypservers is iterable %}--nisserver={{ nis_settings.ypservers[0] }}{% endif %}
    - watch:
        - pkg: ypbind
        - file: ypbind_authconfig
        - file: ypbind_network
    - watch_in:
        - service: ypbind

ypbind_network:
  file.replace:
    - name: /etc/sysconfig/network
    - pattern: ^NISDOMAIN=(?!{{ nis_settings.ypdomain }}).*
    - repl: NISDOMAIN={{ nis_settings.ypdomain }}
    - append_if_not_found: True
    - require:
        - pkg: ypbind

{% endif %}
