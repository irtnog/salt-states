{%- from "pki/map.jinja" import pki with context %}

pki:
  pkg.installed:
    - pkgs: {{
        [ pki.packages ]|yaml if pki.packages is string else
        pki.packages|yaml
      }}
