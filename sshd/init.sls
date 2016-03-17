{% from "sshd/map.jinja" import sshd_settings with context %}

sshd:
  pkg.installed:
    - pkgs: {{ sshd_settings.packages|yaml }}

  file.recurse:
    - name: {{ sshd_settings.config_directory|yaml_encode }}
    - source: salt://sshd/files/
    - template: jinja
    - user: root
    - group: 0
    - dir_mode: 751
    - file_mode: 640
    - require:
        - pkg: sshd

  service.running:
    - name: {{ sshd_settings.services|yaml }}
    - enable: True
    - watch:
        - pkg: sshd
        - file: sshd
