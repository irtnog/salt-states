dig:
  pkg.installed:
    - pkgs:
        {%- if grains['os_family'] == 'Debian' %}
        - dnsutils
        {%- elif grains['os_family'] == 'FreeBSD' %}
        - bind-tools
        {%- elif grains['os_family'] == 'RedHat' %}
        - bind-utils
        {%- else %}
        []
        {%- endif %}
