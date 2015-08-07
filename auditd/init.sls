{% from "auditd/map.jinja" import auditd_settings with context %}

auditd:
  pkg.installed:
    - pkgs: {{ auditd_settings.packages|yaml }}
  service.running:
    - name: {{ auditd_settings.service }}
    - enable: True
    - watch:
        - pkg: auditd
