{% from "nfs/map.jinja" import nfs_client_settings with context %}

nfs_client:
  pkg.installed:
    - pkgs: {{ nfs_client_settings.packages|yaml }}
  service.running:
    - names: {{ nfs_client_settings.services|yaml }}
    - enable: True
    - watch:
      - pkg: nfs_client
