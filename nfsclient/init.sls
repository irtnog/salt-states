{% if grains['os_family'] == 'FreeBSD' %}

nfsclient:
  service:
    - running
    - enable: True
    - watch:
      - service: rpcbind

{% endif %}
