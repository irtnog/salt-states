{% if salt['grains.get']('os_family') in ['RedHat'] %}

tcsh:
  pkg.installed

{% endif %}
