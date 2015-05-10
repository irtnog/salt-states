{% from "rpcbind/map.jinja" import rpcbind with context %}
{% if rpcbind %}

rpcbind:
  {% if rpcbind.packages != None %}
  pkg:
    - installed
    - pkgs:
      {% for package in rpcbind.packages %}
      - {{ package }}
      {% endfor %}
    - require:
      - module: update_repos
    - watch_in:
      - service: rpcbind
  {% endif %}
  service:
    - running
    - name: {{ rpcbind.service }}
    - enable: True

{% endif %}
