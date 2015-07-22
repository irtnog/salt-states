{% from "jetty/map.jinja" import jetty_settings with context %}

jetty:
  pkg.installed:
    - pkgs: {{ jetty_settings.packages|yaml }}
  service.running:
    - name: {{ jetty_settings.service }}
    - enable: True
    - require:
      - file: jetty_dbdir
    - watch:
      - pkg: jetty
