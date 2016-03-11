{% if salt['grains.get']('os_family') in ['Debian', 'FreeBSD', 'RedHat', 'Solaris', 'Suse'] %}

/etc/issue:
  file.managed:
    - source: salt://banners/files/issue
    - user: root
    - group: 0
    - mode: 444

/etc/issue.net:
  file.symlink:
    - target: /etc/issue
    - force: True
    - require:
        - file: /etc/issue

/etc/motd:
  file.managed:
    - source: salt://banners/files/motd
    - user: root
    - group: 0
    - mode: 444

{% endif %}
