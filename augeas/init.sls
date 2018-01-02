{%- from "augeas/map.jinja" import augeas with context %}

augeas:
  pkg.installed:
    - pkgs:
        {{ ([augeas.packages] if augeas.packages is string else augeas.packages)|yaml }}
