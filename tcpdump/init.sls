{% from 'tcpdump/map.jinja' import tcpdump_settings with context %}

tcpdump:
  pkg.installed:
    - pkgs: {{ tcpdump_settings.packages|yaml }}

{% if tcpdump_settings.services %}
  service.running:
    - names: {{ tcpdump_settings.services|yaml }}
    - enable: True
    - watch:
        - pkg: tcpdump
{% endif %}
