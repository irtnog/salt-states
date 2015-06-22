{% if salt['grains.get']('os_family') == 'RedHat' %}

policycoreutils-python:
  pkg.installed

/etc/selinux/targeted/src:
  file.directory:
    - user: root
    - group: root
    - mode: 700

create /etc/selinux/targeted/src/local.te:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - require:
      - file: /etc/selinux/targeted/src

/etc/selinux/targeted/src/local.te:
  file.blockreplace:
    - append_if_not_found: True
    - require:
      - file: create /etc/selinux/targeted/src/local.te

audit2allow -M local:
  cmd.wait:
    - cwd: /etc/selinux/targeted/src
    - require:
      - pkg: policycoreutils-python
    - watch:
      - file: /etc/selinux/targeted/src/local.te

semodule -i local.pp:
  cmd.wait:
    - cwd: /etc/selinux/targeted/src
    - watch:
      - cmd: audit2allow -M local

{% endif %}
