{% from "pki/map.jinja" import pki with context %}
{% if pki %}

pki:
  {% if pki.packages != None %}
  pkg:
    - installed
    - pkgs:
      {% for package in pki.packages %}
      - {{ package }}
      {% endfor %}
  {% endif %}

{% endif %}
