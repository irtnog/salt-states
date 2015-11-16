{% for var, val in salt['pillar.get']('sysctl', {})|dictsort %}
sysctl_{{ loop.index }}:
  sysctl.present:
    - name: {{ var }}
    - value: {{ val }}
{% endfor %}
