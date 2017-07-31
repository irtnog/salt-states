{%- from "gnupg/map.jinja" import gnupg_settings with context %}
{%- set packages = gnupg_settings.packages %%}

gnupg:
  pkg.installed:
    - pkgs: {{ packages|yaml }}
