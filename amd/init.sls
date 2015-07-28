{% from "amd/map.jinja" import amd_settings with context %}

amd:
  pkg.installed:
    - pkgs: {{ amd_settings.packages|yaml }}
  service.running:
    - name: {{ amd_settings.service }}
    - enable: True
    - watch:
      - pkg: amd
      - service: rpcbind
      {% if grains['os_family'] in ['FreeBSD'] %}
      - service: nfsclient
      {% endif %}
      - service: statd
      {% if grains['os_family'] not in ['Debian'] %}
      - service: lockd
      {% endif %}
