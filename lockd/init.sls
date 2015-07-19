{% from "lockd/map.jinja" import lockd_settings with context %}

lockd:
  pkg:
    - installed
    - pkgs: {{ lockd_settings.packages|yaml }}
    - watch_in:
      - service: lockd
  service:
    - running
    - name: {{ lockd_settings.service }}
    - enable: True
    - watch:
      - pkg: lockd
      - service: rpcbind
      {% if grains['os_family'] == 'FreeBSD' %}
      - service: nfsclient
      {% endif %}
