{% if salt['grains.get']('os_family') == 'RedHat' %}

pam_mkhomedir:
  cmd.run:
    - name: authconfig --update {{ '--enablemkhomedir' if salt['pillar.get']('pam_mkhomedir:enable', False) else '--disablemkhomedir' }}

{% endif %}
