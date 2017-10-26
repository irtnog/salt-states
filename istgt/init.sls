{%- from "istgt/map.jinja" import istgt_settings %}

istgt:
  pkg.installed:
    - pkgs: {{ istgt_settings.packages|yaml }}

  service.running:
    - names: {{ istgt_settings.services|yaml }}
    - enable: True
    - watch:
        - pkg: istgt
