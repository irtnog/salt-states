patch_freebsd:
  pkg.uptodate: []

  ## only reboot if patches were installed
  module.run:
    - name: system.reboot
    - kwargs:
        at_time: 1
    - onchanges:
        - pkg: patch_freebsd
