{% from "auditd/map.jinja" import auditd_settings with context %}

auditd:
  pkg.installed:
    - pkgs: {{ auditd_settings.packages|yaml }}
  service.running:
    - names: {{ auditd_settings.services|yaml }}
    - enable: True
    - watch:
        - pkg: auditd
