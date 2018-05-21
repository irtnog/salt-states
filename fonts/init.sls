{% from "fonts/map.jinja" import font_settings with context %}
{% set packages = font_settings.packages %}
{% set install_cmd = font_settings.install_cmd %}
{% set ttf_fonts = font_settings.ttf %}
{% set ttf_prefix = font_settings.ttf_prefix %}
{% set dirsep = '\\' if grains['os_family'] == 'Windows' else '/' %}

fonts:
  pkg.installed:
    - pkgs: {{ packages|yaml }}

  cmd.run:
    - name: {{ install_cmd|yaml_encode }}
    {%- if grains['os_family'] == 'Windows' %}
    - shell: powershell
    {%- endif %}
    - onchanges:
        - pkg: fonts

{% for font_name, settings in ttf_fonts|dictsort %}
ttf_font_{{ loop.index0 }}:
{% if settings is none %}
  file.absent:
{% else %}
  file.managed:
    - source: {{ settings.source|yaml_encode }}
    - source_hash: {{ settings.source_hash|yaml_encode }}
    - makedirs: True
{% endif %}
    - name: {{ '%s%s%s.ttf'|format(ttf_prefix, dirsep, font_name)|yaml_encode }}
    - require:
        - pkg: fonts
    - onchanges_in:
        - cmd: fonts
{% endfor %}
