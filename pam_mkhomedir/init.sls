{% if salt['grains.get']('os_family') == 'RedHat' %}

pam_mkhomedir:
  cmd.run:
    - name: authconfig --update {{ '--enablemkhomedir' if salt['pillar.get']('pam_mkhomedir:enable', False) else '--disablemkhomedir' }}

pam_mkhomedir_selinux_exception:
  file.accumulated:
    - filename: /etc/selinux/targeted/local/local.te
    - text: |
        #============= unconfined_t ==============
        allow unconfined_t oddjob_mkhomedir_exec_t:file entrypoint;
    - require_in:
      - file: /etc/selinux/targeted/local/local.te

{% endif %}
