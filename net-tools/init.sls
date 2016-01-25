{% if salt['grains.get']('os_family') == 'RedHat' %}

## for netstat, arp, et al on RHEL/CentOS
net-tools:
  pkg.installed

{% endif %}
