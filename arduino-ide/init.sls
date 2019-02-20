arduino-ide:
  pkg.installed:
    - pkgs:
        - gcc
        - gcc-avr
        - avrdude
        - avrdude-doc
        - avr-libc
        - default-jre
        - libjna-java
        - librxtx-java

  archive.extracted:
    - name: /opt
    - source: https://downloads.arduino.cc/arduino-1.8.8-linux64.tar.xz
    - source_hash: https://downloads.arduino.cc/arduino-1.8.8.md5sum.txt
    - keep_source: True         # it's a big download
    - user: root
    - group: root
