{% from "lockd/map.jinja" import lockd with context %}
{% if lockd %}

lockd:
  {% if lockd.packages %}
  pkg:
    - installed
    - pkgs:
      {% for package in lockd.packages %}
      - {{ package }}
      {% endfor %}
    - watch_in:
      - service: lockd
  {% endif %}
  service:
    - running
    - name: {{ lockd.service }}
    - enable: True
    - watch:
      - service: rpcbind

{% endif %}
