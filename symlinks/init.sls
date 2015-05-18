{% for symlink in salt['pillar.get']('symlinks', []) %}
{{ symlink.name }}:
  file.symlink:
    - target: {{ symlink.target }}
{% endfor %}
