patch_windows:
  module.run:
    - name: win_wua.list_updates
    - Categories:
        - name:
            - Critical Updates
            - Security Updates
    - install: true

  ## only reboot if patches were installed
  module.run:
    - name: system.reboot
    - kwargs:
        at_time: 1
    - onchanges:
        - module: patch_windows
