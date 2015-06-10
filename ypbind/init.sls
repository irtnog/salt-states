## TODO: add support for Debian/Ubuntu, SLE/OpenSUSE, Solaris

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
    - name: salt://ypbind/files/enable-passwd-map.sh

ypbind_group:
  file.append:
    - name: /etc/group
    - text: +:*::

{% elif grains['os_family'] == 'RedHat' %}
ypbind_conf:
  file.blockreplace:
    - name: /etc/yp.conf
    - append_if_not_found: True
    - require:
      - pkg: ypbind

{% for server in ypbind_settings.servers %}
ypbind_conf_domain_server_{{ loop.index }}:
  file.accumulated:
    - name: ypbind_conf_accumulator
    - filename: /etc/yp.conf
    - text: domain {{ ypbind_settings.domain }} server {{ server }}
    - require_in:
      - file: ypbind_conf

{% else %}
ypbind_conf_domain_broadcast:
  file.accumulated:
    - name: ypbind_conf_accumulator
    - filename: /etc/yp.conf
    - text: domain {{ ypbind_settings.domain }} broadcast
    - require_in:
      - file: ypbind_conf
{% endfor %}

{% for element in ['passwd', 'shadow', 'group', 'hosts', 'netgroup', 'automount'] %}
ypbind_nsswitch_{{ element }}:
  file.replace:
    - name: /etc/nsswitch.conf
    - pattern: ^({{ element }}:\s+files)(?! nis)(.*)
    - repl: \1 nis\2
{% endfor %}

{% endif %}
