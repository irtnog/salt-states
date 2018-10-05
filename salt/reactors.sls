{% from "salt/map.jinja" import salt_settings with context %}

salt-reactor-scripts:
  pkg.installed:
    - name: py27-mako

  file.recurse:
    - name: {{ salt_settings.config_path }}/reactors
    - source: salt://{{ slspath }}/files/reactors
    - template: mako
    - clean: yes
    - dir_mode: 700
    - file_mode: 500
    - include_empty: yes
    - require:
        - pkg: salt-reactor-scripts
