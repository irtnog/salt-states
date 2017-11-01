{%- from "emacs/map.jinja" import emacs_settings with context %}

emacs:
{%- if 'ppa' in emacs_settings %}
  pkgrepo.managed:
    - ppa: {{ emacs_settings.ppa|yaml_encode }}
    - require_in:
        - pkg: emacs
{%  else %}
{%- endif %}
  pkg.installed:
    - pkgs: {{ emacs_settings.packages|yaml }}
