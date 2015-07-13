{% from "lockd/map.jinja" import lockd with context %}
{% if lockd %}

lockd:
  pkg:
    - installed
    - pkgs: {{ lockd.packages|yaml }}
    - watch_in:
      - service: lockd
  service:
    - running
    - name: {{ lockd.service }}
    - enable: True
    - watch:
      - pkg: lockd
      - service: rpcbind

{% endif %}
