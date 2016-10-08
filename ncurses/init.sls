{% from "ncurses/map.jinja" import ncurses_settings with context %}

ncurses:
  pkg.installed:
    - pkgs: {{ ncurses_settings.packages|yaml }}
