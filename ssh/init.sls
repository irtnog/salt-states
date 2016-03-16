{% from "ssh/map.jinja" import ssh_settings with context %}

ssh:
  pkg.installed:
    - pkgs: {{ ssh_settings.packages|yaml }}

  file.recurse:
    - name: {{ ssh_settings.config_directory|yaml_encode }}
    - source: salt://ssh/files/
    - template: jinja
    - user: root
    - group: 0
    - dir_mode: 755
    - file_mode: 644
    - require:
        - pkg: ssh
