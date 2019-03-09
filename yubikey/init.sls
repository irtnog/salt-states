yubikey:
  pkg.installed:
    - pkgs:
{%- if grains['os_family'] == 'Debian' %}
        - yubico-piv-tool
        - yubikey-personalization
{%-   if pillar['role'] in ['desktop', 'laptop'] %}
        - yubikey-piv-manager
        - yubikey-personalization-gui
{%-   endif %}
{%- elif grains['os_family'] == 'Windows' %}
        - yubikey-personalization-tool
{%- else %}
        []
{%- endif %}
