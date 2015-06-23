## TODO: add support for Debian/Ubuntu, SLE/OpenSUSE, Solaris

{% if grains['kernel'] in ['FreeBSD', 'Linux', 'Solaris'] %}
{% from "ypbind/map.jinja" import ypbind_settings with context %}

ypbind:
  {% if ypbind_settings.packages %}
  pkg.installed:
    - pkgs:
      {% for package in ypbind_settings.packages %}
      - {{ package }}
      {% endfor %}
    - watch_in:
      - service: ypbind
  {% endif %}
  file.managed:
    - name: /etc/domainname
    - user: root
    - group: 0
    - mode: 444
    - contents: {{ ypbind_settings.domain }}
  service.running:
    - name: {{ ypbind_settings.service }}
    - enable: True
    - watch:
      - file: ypbind
      - service: rpcbind

{% if grains['os_family'] == 'FreeBSD' %}
rc_conf_nisdomainname:
  file.accumulated:
    - name: rc_conf_accumulator
    - filename: /etc/rc.conf
    - text: nisdomainname="{{ ypbind_settings.domain }}"
    - require_in:
      - file: rc_conf
    - watch_in:
      - service: ypbind

rc_conf_nis_client_flags:
  file.accumulated:
    - name: rc_conf_accumulator
    - filename: /etc/rc.conf
    - text: nis_client_flags="-m -S {{ ypbind_settings.domain }}{%- for server in ypbind_settings.servers -%},{{ server }}{%- endfor -%}"
    - require_in:
      - file: rc_conf
    - watch_in:
      - service: ypbind

ypbind_passwd:
  cmd.script:
    - name: salt://ypbind/files/freebsd-enable-nis-passwd-map.sh

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
    - name: authconfig --update --enablenis --nisdomain={{ ypbind_settings.domain }} {% if ypbind_settings.servers is iterable %}--nisserver={{ ypbind_settings.servers[0] }}{% endif %}
    - watch:
      - pkg: ypbind
      - file: ypbind
      - file: ypbind_authconfig
      - file: ypbind_network

ypbind_network:
  file.replace:
    - name: /etc/sysconfig/network
    - pattern: ^NISDOMAIN=(?!{{ ypbind_settings.domain }}).*
    - repl: NISDOMAIN={{ ypbind_settings.domain }}
    - append_if_not_found: True
    - require:
      - pkg: ypbind
{% endif %}

{% endif %}
