pwm:
  pkg.installed:
    - pkgs:
        - mysql-connector-java
        - tomcat

  file.managed:
    - name: /opt/pwm/pwm.jar
    - source: https://www.pwm-project.org/artifacts/pwm/2018-05-16T18_58_17Z/pwm-1.8.0-SNAPSHOT.war
    - source_hash: sha256=639390da4e70f7730157675f459aae1e09ead28fcade2541166555d2d065bdf6
    - user: tomcat
    - group: tomcat
    - dir_mode: 751
    - file_mode: 640
    - makedirs: True

pwm_config:
  file.managed:
    - name: /opt/pwm/data/PwmConfiguration.xml
    - source: salt://pwm/files/PwmConfiguration.xml
    - template: jinja
    - user: tomcat
    - group: tomcat
    - mode: 640
