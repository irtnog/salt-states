{% from "clamav/map.jinja" import clamav_settings with context %}

clamav:
  pkg.installed:
    - pkgs: {{ clamav_settings.packages|yaml }}
  service.running:
    - names: {{ clamav_settings.services|yaml }}
    - enable: True
    - watch:
        - pkg: clamav
        - file: clamd_conf
        - file: freshclam_conf
        - cmd: freshclam

clamd_conf:
  file.managed:
    - name: {{ clamav_settings.clamd_conf }}
    - contents: |
        {% for key, value in clamav_settings.clamd|dictsort -%}
        {% if value == True or value == False -%}
        {{ key }} {{ "yes" if value else "no" }}
        {% else -%}
        {{ key }} {{ value }}
        {% endif -%}
        {% else -%}
        ## Nothing to see here.  Move along.
        {%- endfor %}
    - user: root
    - group: 0
    - mode: 444
    - require:
        - pkg: clamav

freshclam_conf:
  file.managed:
    - name: {{ clamav_settings.freshclam_conf }}
    - contents: |
        {% for key, value in clamav_settings.freshclam|dictsort -%}
        {% if value == True or value == False -%}
        {{ key }} {{ "yes" if value else "no" }}
        {% else -%}
        {{ key }} {{ value }}
        {% endif -%}
        {% else -%}
        ## Nothing to see here.  Move along.
        {%- endfor %}
    - user: root
    - group: 0
    - mode: 444
    - require:
        - pkg: clamav

freshclam:
  cmd.run:
    - onlyif: test ! -s {{ clamav_settings.dbdir }}/main.cvd \
                -o ! -s {{ clamav_settings.dbdir }}/daily.cvd \
                -o ! -s {{ clamav_settings.dbdir }}/bytecode.cvd
    - require:
        - file: freshclam_conf
        - file: clamd_conf

{% if grains['os_family'] == 'RedHat' %}
/etc/sysconfig/freshclam:
  file.replace:
    - pattern: '^.*REMOVE ME.*$'
    - repl: ''
    - flags:
        - DOTALL
    - require:
        - pkg: clamav
{% endif %}
