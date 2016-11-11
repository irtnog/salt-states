{% from "auditd/map.jinja" import auditd_settings with context %}

auditd:
  pkg.installed:
    - pkgs: {{ auditd_settings.packages|yaml }}
{% if 'audit_in_linux_kernel' not in grains
   or grains['audit_in_linux_kernel'] %}
  service.running:
    - names: {{ auditd_settings.services|yaml }}
    - enable: True
    - watch:
        - pkg: auditd
{% else %}
  service.dead:
    - names: {{ auditd_settings.services|yaml }}
    - enable: False
{% endif %}
