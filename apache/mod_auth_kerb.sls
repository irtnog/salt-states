{% from "apache/map.jinja" import apache with context %}

include:
  - apache

mod_auth_kerb:
  pkg.installed:
    - name: {{ apache.mod_auth_kerb }}
    - require:
        - pkg: apache
    - watch_in:
        - module: apache-restart
