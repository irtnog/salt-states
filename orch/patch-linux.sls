orch_patch_linux_install:
  salt.function:
    - name: pkg.upgrade
    - tgt: 'I@environment:{{ saltenv }} and G@kernel:Linux'
    - tgt_type: compound

orch_patch_linux_reboot:
  salt.function:
    - name: system.reboot
    - tgt: 'I@environment:{{ saltenv }} and G@kernel:Linux'
    - tgt_type: compound
    - kwarg:
        at_time: 1
    - require:
        - salt: orch_patch_linux_install
