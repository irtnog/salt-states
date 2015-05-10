{% for alias, target in salt['pillar.get']('aliases', {}).items() %}
{{ alias }}:
  alias.present:
    - target: {{ target }}
{% endfor %}
