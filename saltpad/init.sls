{% from "saltpad/map.jinja" import saltpad_settings with context %}

saltpad:
  pkg.installed:
    - pkgs: {{ saltpad_settings.packages|yaml }}
