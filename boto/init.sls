{%- from "boto/map.jinja" import boto_settings with context %}

boto:
  pkg.installed:
    - pkgs: {{ boto_settings.packages|yaml }}
    - reload_modules: True
