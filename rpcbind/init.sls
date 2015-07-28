{% from "rpcbind/map.jinja" import rpcbind_settings with context %}

rpcbind:
  pkg.installed:
    - pkgs: {{ rpcbind_settings.packages|yaml }}
  service.running:
    - name: {{ rpcbind_settings.service }}
    - enable: True
    - watch:
      - pkg: rpcbind
