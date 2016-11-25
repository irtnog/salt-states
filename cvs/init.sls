{% from "cvs/map.jinja" import cvs_settings with context %}

cvs:
  pkg.installed:
    - pkgs: {{ cvs_settings.packages|yaml }}
