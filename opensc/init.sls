{%- from 'opensc/map.jinja' import opensc with context %}
{%- set packages = opensc['packages'] %}

opensc:
  pkg.installed:
    - pkgs: {{ packages|yaml }}
