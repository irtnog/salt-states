{% from "nfs/map.jinja" import nfs_settings with context %}

nfs_client:
  pkg.installed:
    - pkgs: {{ nfs_settings.client_packages|yaml }}
  service.running:
    - names: {{ nfs_settings.client_services|yaml }}
    - enable: True
    - watch:
      - pkg: nfs_client
