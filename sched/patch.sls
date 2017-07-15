auto-update:
  pkg.installed:
    - pkgs:
{%- if salt.grains.get('os_family') == 'FreeBSD' %}
        - py27-dateutil
{%- elif salt.grains.get('os_family') in ['Debian', 'RedHat'] %}
        - python-dateutil       # FIXME
{%- endif %}

  schedule.present:
    - function: state.apply
    - job_args:
        - patch-{{ salt.grains.get('kernel')|lower }}
    - when:
{%- if salt.pillar.get('role') == 'salt-master' %}
        - Saturday 1:00am
{%- else %}
        - Saturday 3:00am
{%- endif %}
    - require:
        - pkg: auto-update

## TODO: add returner
