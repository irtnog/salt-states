{%- from "emacs/map.jinja" import emacs with context %}

emacs:
{%- if emacs['ppa']|default(None) %}
  pkgrepo.managed:
    - ppa: {{ emacs.ppa|yaml_encode }}
    - require_in:
        - pkg: emacs
{%- endif %}
  pkg.installed:
    - pkgs: {{ emacs.packages|yaml }}
