tightvnc:
  pkg.installed:
    []

  service.dead:
    - name: tvnserver
    - enable: False
