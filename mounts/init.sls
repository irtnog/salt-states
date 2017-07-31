{% for mount in salt['pillar.get']('mounts', []) %}
{{ mount.get('path') }}:
  file.directory: []

  mount.mounted:
    - device:   {{ mount.get('device') }}
    - fstype:   {{ mount.get('fstype') }}
    - opts:     {{ mount.get('options', 'rw') }}
    - dump:     {{ mount.get('dumpfreq', 0) }}
    - pass_num: {{ mount.get('passno', 0) }}
{% endfor %}
