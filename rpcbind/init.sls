{% from "rpcbind/map.jinja" import rpcbind with context %}
{% if rpcbind %}

rpcbind:
  pkg:
    - installed
    - pkgs: {{ rpcbind.packages|yaml }}
  service:
    - running
    - name: {{ rpcbind.service }}
    - enable: True
    - watch:
      - pkg: rpcbind

{% endif %}
