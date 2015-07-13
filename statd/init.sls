{% from "statd/map.jinja" import statd with context %}
{% if statd %}

statd:
  pkg:
    - installed
    - pkgs: {{ statd.packages|yaml }}
  service:
    - running
    - name: {{ statd.service }}
    - enable: True
    - watch:
      - pkg: statd
      - service: rpcbind
      {% if grains['os_family'] == 'FreeBSD' %}
      - service: nfsclient
      {% endif %}

{% endif %}
