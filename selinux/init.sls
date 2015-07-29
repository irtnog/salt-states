{% if salt['grains.get']('os_family') == 'RedHat' %}

policycoreutils-python:
  pkg.installed

/etc/selinux/targeted/local:
  file.directory:
    - user: root
    - group: root
    - mode: 700

/etc/selinux/targeted/local/local.te:
  file.managed:
    - name: /etc/selinux/targeted/local/local.te
    - source: salt://selinux/files/local.te
    - user: root
    - group: root
    - mode: 600
    - require:
      - file: /etc/selinux/targeted/local

checkmodule -M -m -o local.mod local.te:
  cmd.wait:
    - cwd: /etc/selinux/targeted/local
    - require:
      - pkg: policycoreutils-python
    - watch:
      - file: /etc/selinux/targeted/local/local.te

semodule_package -o local.pp -m local.mod:
  cmd.wait:
    - cwd: /etc/selinux/targeted/local
    - watch:
      - cmd: checkmodule -M -m -o local.mod local.te

semodule -i local.pp:
  cmd.wait:
    - cwd: /etc/selinux/targeted/local
    - watch:
      - cmd: semodule_package -o local.pp -m local.mod

{% endif %}