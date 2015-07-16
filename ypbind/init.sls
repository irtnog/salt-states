{% from "ypbind/map.jinja" import ypbind_settings with context %}

ypbind:
  pkg.installed:
    - pkgs: {{ ypbind_settings.packages|yaml }}
  file.blockreplace:
    - name: /etc/yp.conf
    - marker_start: '#-- {{ sls }}: start managed zone --'
    - marker_end:   '#-- {{ sls }}: end managed zone --'
    - append_if_not_found: True
    - contents: |
      {%- for server in ypbind_settings.servers %}
        domain {{ ypbind_settings.domain }} server {{ server }}
      {% else %}
        domain {{ ypbind_settings.domain }} broadcast
      {%- endfor %}
    - require:
      - pkg: ypbind
  service.running:
    - name: {{ ypbind_settings.service }}
    - enable: True
    - watch:
      - pkg: ypbind
      - file: ypbind
      - file: ypbind_domainname
      - service: rpcbind

ypbind_domainname:
  file.managed:
    - name: /etc/domainname
    - user: root
    - group: 0
    - mode: 444
    - contents: {{ ypbind_settings.domain }}
    - require:
      - pkg: ypbind

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

nisdomain:
  service.running:
    - watch:
      - file: rc_conf_nisdomainname
    - require_in:
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
      - file: ypbind_domainname
      - file: ypbind_authconfig
      - file: ypbind_network
    - watch_in:
      - service: ypbind

ypbind_network:
  file.replace:
    - name: /etc/sysconfig/network
    - pattern: ^NISDOMAIN=(?!{{ ypbind_settings.domain }}).*
    - repl: NISDOMAIN={{ ypbind_settings.domain }}
    - append_if_not_found: True
    - require:
      - pkg: ypbind
{% endif %}
