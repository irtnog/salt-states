{% from "salt/map.jinja" import salt_settings with context %}

salt-reactor-scripts:
  file.recurse:
    - name: {{ salt_settings.config_path }}/reactors
    - template: jinja
    - source: salt://{{ slspath }}/files/reactors
    - clean: yes
    - dir_mode: 700
    - file_mode: 500
      include_empty: yes
    - watch_in:
        - service: salt-master
