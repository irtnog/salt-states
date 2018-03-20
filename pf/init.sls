pf:
  file.recurse:
    - name: /etc
    - source: salt://pf/files
    - template: jinja

  service.running:
    - enable: True
    - watch:
        - file: pf
