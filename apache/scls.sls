{%- from "apache/map.jinja" import apache with context %}

{%- if salt['grains.get']('os_family') == 'RedHat' %}

include:
  - apache

apache_scls:
  file.replace:
    - name: /opt/rh/httpd24/service-environment
    - pattern:
        'HTTPD24_HTTPD_SCLS_ENABLED="httpd24[^"]*"'
    - repl:
        'HTTPD24_HTTPD_SCLS_ENABLED="httpd24{{ ([''] + apache.scls)|join(' ') }}"'
    - require:
        - pkg: apache
    - watch_in:
        - module: apache-restart

{%- endif %}
