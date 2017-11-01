lightdm:
  pkg.installed: []

  file.recurse:
    - name: /etc/lightdm
    - source: salt://lightdm/files/
    - template: jinja
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - require:
        - pkg: lightdm

  service.running:
    - enable: True
    - watch:
        - pkg: lightdm
        - file: lightdm
