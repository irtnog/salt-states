{% if salt['grains.get']('os_family') in ['FreeBSD', 'RedHat'] %}
{% from "amd/map.jinja" import amd_settings with context %}

amd:
  {% if amd_settings.packages %}
  pkg:
    - installed
    - pkgs:
      {% for package in amd_settings.packages %}
      - {{ package }}
      {% endfor %}
    - watch_in:
      - service: amd
  {% endif %}
  service:
    - running
    - name: {{ amd_settings.service }}
    - enable: True
    - watch:
      - service: rpcbind
      {% if grains['os_family'] == 'FreeBSD' %}
      - service: nfsclient
      {% endif %}
      - service: statd
      - service: lockd

{% endif %}
