{%- from "rsat/map.jinja" import rsat_settings with context %}

rsat:
  dism.package_installed:
    - names:
        {{ rsat_settings.dism_packages|yaml }}
