{% from "wsus/map.jinja" import wsus_settings with context %}

wsus:
  pkg.installed:
    - pkgs: {{ wsus_settings.packages|yaml }}
  windows_feature.enabled:
    - names: {{ wsus_settings.features|yaml }}
    - require:
        - pkg: wsus
  service.running:
    - names: {{ wsus_settings.services|yaml }}
    - enable: True
    - watch:
        - pkg: wsus
        - windows_feature: wsus

## TODO: schedule maintenance script
