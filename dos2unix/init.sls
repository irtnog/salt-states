{% if grains['os_family'] == 'FreeBSD' %}
unix2dos:
  pkg.installed
{% else %}
dos2unix:
  pkg.installed
{% endif %}
