{% for alias, target in salt['pillar.get']('aliases', {})|dictsort %}
{{ alias }}:
  alias.present:
    - target: {{ target }}
{% endfor %}
