{% from "pki/map.jinja" import pki with context %}
{% if pki %}

pki:
  pkg.installed:
    - pkgs: {{ pki.packages|yaml }}

{% endif %}
