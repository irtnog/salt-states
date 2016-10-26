vault:
  pkg.installed:
    - pkgs:
        - vault
        - vim                   # for `xxd -r`

  file.managed:
    - name: /usr/local/etc/vault.hcl
    - source: salt://vault/files/vault.hcl
    - template: jinja
    - user: root
    - group: vault
    - mode: 640

  service.running:
    - enable: True
    - watch:
        - pkg: vault
        - file: vault
        - file: vault_backend_file

vault_backend_file:
  file.directory:
    - name: /var/db/vault
    - user: vault
    - group: vault
    - mode: 751

{% if grains['kernel'] == 'FreeBSD' %}
vault_allow_unprivileged_mlock:
  sysctl.present:
    - name: security.bsd.unprivileged_mlock
    - value: 1
    - watch_in:
        - service: vault

## TODO: profile service and create login class with a suitable
## RLIMIT_MEMLOCK
vault_bypass_rlimit_memlock:
  sysctl.present:
    - name: vm.old_mlock
    - value: 1
    - watch_in:
        - service: vault
{% endif %}

{% if grains['kernel'] == 'Linux' %}
vault_allow_unprivileged_mlock:
  cmd.run:
    - name: setcap cap_ipc_lock=+ep $(readlink -f $(which vault))
    - require_in:
        - service: vault
{% endif %}
