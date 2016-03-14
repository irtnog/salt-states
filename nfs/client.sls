{% from "nfs/map.jinja" import nfs_settings with context %}

nfs_client:
  pkg.installed:
    - pkgs: {{ nfs_settings.client_packages|yaml }}
  service.running:
    - names: {{ nfs_settings.client_services|yaml }}
    - enable: True
    - watch:
        - pkg: nfs_client

{% if salt['grains.get']('os_family') in ['Debian', 'Suse'] %}
automounter_enable_config_dir:
  file.replace:
    - name: /etc/auto.master
    - pattern: '^#(\+dir:/etc/auto.master.d)'
    - repl: '\1'
    - watch_in:
        - service: nfs_client

automounter_enable_hosts_map:
  file.recurse:
    - name: /etc/auto.master.d
    - source: salt://nfs/files/auto.master.d
    - user: root
    - group: 0
    - dir_mode: 755
    - file_mode: 444
    - watch_in:
        - service: nfs_client
{% endif %}