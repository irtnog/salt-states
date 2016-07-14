{% from 'tcpdump/map.jinja' import tcpdump_settings with context %}

tcpdump:
  pkg.installed:
    - pkgs: {{ tcpdump_settings.packages|yaml }}

  service.running:
    - names: {{ tcpdump_settings.services|yaml }}
    - enable: True
