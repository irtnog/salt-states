opentracker:
  pkg.installed: []

  file.recurse:
    - name: /usr/local/etc/opentracker
    - source: salt://opentracker/files
    - dir_mode: 755
    - file_mode: 644
    - template: jinja
    - require:
        - pkg: opentracker

  service.running:
    - enable: True
    - watch:
        - pkg: opentracker
        - file: opentracker
