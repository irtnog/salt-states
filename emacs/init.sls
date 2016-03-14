{% from "emacs/map.jinja" import emacs_settings with context %}

emacs:
  pkg.installed:
    - pkgs: {{ emacs_settings.packages|yaml }}
