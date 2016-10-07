/etc/freebsd-update.conf:
  file.managed:
    - source: salt://freebsd-update/files/freebsd-update.conf
