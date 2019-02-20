include:
  - arduino-ide

teensyduino:
  file.managed:
    - name: /etc/udev/rules.d/49-teensy.rules
    - source: https://www.pjrc.com/teensy/49-teensy.rules
    - skip_verify: True
    - keep_source: True

  archive.extracted:
    - name: /opt
    - source: salt://teensyduino/dist/teensyduino-1.8.8-linux64.tar.xz
    - keep_source: True         # it's a big download
    - user: root
    - group: root
    - require:
        - archive: arduino-ide
