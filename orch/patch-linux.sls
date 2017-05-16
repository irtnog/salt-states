## Patch all computers running Linux in the current environment.
orch_patch_linux:
  salt.state:
    - tgt: 'G@kernel:Linux and I@environment:{{ saltenv }} and not I@role:salt-master'
    - tgt_type: compound
    - sls:
        - patch-linux

## Do the Salt master last so as to not interrupt the orchestrate
## runner.
orch_patch_linux_salt_master:
  salt.state:
    - tgt: 'G@kernel:Linux and I@environment:{{ saltenv }} and I@role:salt-master'
    - tgt_type: compound
    - sls:
        - patch-linux
    - require:
        - salt: orch_patch_linux
