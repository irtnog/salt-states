{% from "auditd/map.jinja" import auditd with context %}
{% if auditd %}

auditd:
  {% if auditd.packages %}
  pkg:
    - installed
    - pkgs:
      {% for package in auditd.packages %}
      - {{ package }}
      {% endfor %}
    - watch_in:
      - service: auditd
  {% endif %}
  service:
    - running
    - name: {{ auditd.service }}
    - enable: True

{% endif %}
