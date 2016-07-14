{% from "pki/map.jinja" import pki_settings with context %}

pki:
  pkg.installed:
    - pkgs: {{ pki_settings.packages|yaml }}
