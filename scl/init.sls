{% if grains['osfinger'].startswith('CentOS') %}
centos-release-scl:
  pkg.installed: []

{% else %}
{# TODO: enable the Software Collections and Optional channels #}

{% endif %}
