{% from "apache/map.jinja" import apache_settings with context %}

apache:
  pkg.installed:
    - pkgs: {{ apache_settings.packages|yaml }}
  service.running:
    - name: {{ apache_settings.service }}
    - enable: True
    - require:
      - file: apache_dbdir
    - watch:
      - pkg: apache

apache_dbdir:
  file.directory:
    - name: {{ apache_settings.dbdir }}
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - dir_mode: 710
    - require:
      - pkg: apache

{% for module in apache_settings.modules %}
apache_{{ module }}_module:
  file.managed:
    - name: {{ apache_settings.confdir }}_{{ "%03d"|format(loop.index) }}_mod_{{ module }}.conf
    - source: salt://apache/files/mod_template.conf.jinja
    - template: jinja
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - mode: 400
    - require:
      - pkg: apache
    - watch_in:
      - service: apache
{% endfor %}
