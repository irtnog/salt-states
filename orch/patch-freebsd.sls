## Patch all computers running FreeBSD in the current environment.
orch_patch_freebsd:
  salt.state:
    - tgt: 'G@kernel:FreeBSD and I@environment:{{ saltenv }} and not I@role:salt-master'
    - tgt_type: compound
    - saltenv: {{ saltenv }}
    - sls:
        - patch-freebsd

## Do the Salt master last so as to not interrupt the orchestrate
## runner.
orch_patch_freebsd_salt_master:
  salt.state:
    - tgt: 'G@kernel:FreeBSD and I@environment:{{ saltenv }} and I@role:salt-master'
    - tgt_type: compound
    - saltenv: {{ saltenv }}
    - sls:
        - patch-freebsd
    - require:
        - salt: orch_patch_freebsd
