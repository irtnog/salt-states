yubikey:
  pkg.installed:
    - pkgs:
{%- if grains['os_family'] == 'Debian' %}
{%-   if pillar['role'] in ['desktop', 'laptop'] %}
        - yubikey-personalization-gui
{%-   else %}
        - yubikey-personalization
{%-   endif %}
{%- elif grains['os_family'] == 'Windows' %}
        - yubikey-personalization-tool
{%- else %}
        []
{%- endif %}
