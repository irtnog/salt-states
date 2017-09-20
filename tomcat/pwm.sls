{%- from "tomcat/map.jinja" import tomcat with context %}

include:
  - pwm
  - tomcat
  - tomcat.config

extend:
  tomcat:
    pkg:
      - require_in:
          - file: pwm
    service:
      - watch:
          - pkg: pwm
          - file: pwm
          - archive: pwm

pwm_tomcat:
  file.managed:
    - name: {{ tomcat.conf_dir }}/Catalina/localhost/pwm.xml
    - source: salt://tomcat/files/pwm.xml
    - require:
        - pkg: tomcat
    - watch_in:
        - service: tomcat

pwm_tomcat_semanage_fcontext_add:
  selinux.fcontext_policy_present:
    - name: /opt/pwm/data(/.*)?
    - sel_type: tomcat_cache_t
    - require:
        - pkg: tomcat

pwm_tomcat_restorecon:
  selinux.fcontext_policy_applied:
    - name: /opt/pwm/data
    - recursive: True
    - require:
        - archive: pwm
        - selinux: pwm_tomcat_semanage_fcontext_add
    - watch_in:
        - service: tomcat
