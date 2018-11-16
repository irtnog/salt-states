{%- set os_family = salt['grains.get']('os_family') %}
{%- if os_family == 'FreeBSD' %}

py27-dateutil:
  pkg.installed:
    []

{%- elif os_family in ['Debian', 'RedHat'] %}

python-dateutil:
  pkg.installed:
    []

{%- elif os_family == 'Windows' %}

python-dateutil:
  pip.installed:
    - cwd: 'C:\salt\bin\Scripts'
    - bin_env: 'C:\salt\bin\Scripts\pip.exe'
    - upgrade: True
    - reload_modules: True

{%- endif %}
