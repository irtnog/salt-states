{%- from "pki/map.jinja" import pki with context %}

pki:
  pkg.installed:
    - pkgs: {{
        [ pki.packages ]|yaml if pki.packages is string else
        pki.packages|yaml
      }}

{%- if pki.anchor_dir %}
  file.recurse:
    - name: {{ pki.anchor_dir|yaml_encode }}
    - source: salt://pki/anchors/
    - user: root
    - group: 0
    - file_mode: 644
    - dir_mode: 755
    - exclude_pat: E@\.gitignore
    - require:
        - pkg: pki

  cmd.run:
{%-   if salt['grains.get']('osfamily') == 'Windows' %}
    - shell: powershell
{%-   endif %}
    - name: {{ pki.update_cmd|yaml_encode }}
    - onchanges:
        - file: pki
{%- endif %}
