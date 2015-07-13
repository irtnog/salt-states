{% from "auditd/map.jinja" import auditd with context %}
{% if auditd %}

auditd:
  pkg:
    - installed
    - pkgs: {{ auditd.packages|yaml }}
  service:
    - running
    - name: {{ auditd.service }}
    - enable: True
    - watch:
      - pkg: auditd

{% endif %}
