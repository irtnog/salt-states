skype:
  pkg.installed:
    - pkgs:
{%- if salt.grains.get('os_family') == 'Windows' %}
        - skype-msi
{%- else %}
        []
{%- endif %}
