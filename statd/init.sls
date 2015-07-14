{% from "statd/map.jinja" import statd_settings with context %}

statd:
  pkg:
    - installed
    - pkgs: {{ statd_settings.packages|yaml }}
  service:
    - running
    - name: {{ statd_settings.service }}
    - enable: True
    - watch:
      - pkg: statd
      - service: rpcbind
      {% if grains['os_family'] == 'FreeBSD' %}
      - service: nfsclient
      {% endif %}
