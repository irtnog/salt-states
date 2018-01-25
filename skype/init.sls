skype:
  pkg.installed:
    - pkgs:
{%- if salt['grains.get']('os_family') == 'Windows' %}
        - skype-msi
{%- else %}
        []
{%- endif %}

  host.present:
    - name: apps.skype.com
    - ip: 127.0.0.1
