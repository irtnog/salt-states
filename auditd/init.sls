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
    - require:
      - module: update_repos
    - watch_in:
      - service: auditd
  {% endif %}
  service:
    - running
    - name: {{ auditd.service }}
    - enable: True

{% endif %}
