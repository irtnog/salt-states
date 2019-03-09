yubikey:
  pkg.installed:
    - pkgs:
{%- if grains['os_family'] == 'Debian' %}
        - yubikey-personalization
{%-   if pillar['role'] in ['desktop', 'laptop'] %}
        - yubikey-personalization-gui
{%-   endif %}
{%- elif grains['os_family'] == 'Windows' %}
        - yubikey-personalization-tool
{%- else %}
        []
{%- endif %}
