{% from "p7zip/map.jinja" import p7zip_settings with context %}

p7zip:
  pkg.installed:
    - pkgs: {{ p7zip_settings.packages|yaml }}
