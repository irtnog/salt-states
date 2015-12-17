{% if salt['grains.get']('os_family') == 'RedHat' %}

deltarpm:
  pkg.installed

{% endif %}
