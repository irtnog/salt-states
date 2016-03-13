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
rc_conf_nisdomainname:
  file.accumulated:
    - name: rc_conf_accumulator
    - filename: /etc/rc.conf
    - text: nisdomainname="{{ nis_settings.ypdomain }}"
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
    - text: nis_client_flags="-m -S {{ nis_settings.ypdomain }}{%- for server in nis_settings.ypservers -%},{{ server }}{%- endfor -%}"
    - require_in:
        - file: rc_conf
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
