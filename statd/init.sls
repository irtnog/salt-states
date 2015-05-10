{% from "statd/map.jinja" import statd with context %}
{% if statd %}

statd:
  {% if statd.packages %}
  pkg:
    - installed
    - pkgs:
      {% for package in statd.packages %}
      - {{ package }}
      {% endfor %}
    - require:
      - module: update_repos
    - watch_in:
      - service: statd
  {% endif %}
  service:
    - running
    - name: {{ statd.service }}
    - enable: True
    - watch:
      - service: rpcbind
      {% if grains['os_family'] == 'FreeBSD' %}
      - service: nfsclient
      {% endif %}

{% endif %}
