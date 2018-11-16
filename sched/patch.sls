auto-update:
  schedule.present:
    - function: state.apply
    - job_args:
        - patch
    - job_kwargs:
        saltenv: {{ saltenv }}
    - when:
{%- if salt['pillar.get']('role') == 'salt-master' %}
        - Saturday 1:00am
{%- else %}
        - Saturday 3:00am
{%- endif %}

## TODO: add returner
