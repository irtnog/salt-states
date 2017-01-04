bgfsck:
  service.disabled: []

  sysrc.managed:
    - name: fsck_y_enable
    - value: "YES"
