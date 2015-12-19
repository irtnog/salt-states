{% if salt['grains.get']('os_family') == 'RedHat' %}

deltarpm:
  pkg.installed

yum-cron:
  pkg.installed

{% endif %}
