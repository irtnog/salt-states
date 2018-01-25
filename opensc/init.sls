opensc:
  pkg.installed:
    - pkgs:
        - opensc-win32          # install the 32-bit package
{%- if salt['grains.get']('cpuarch') == 'AMD64' %}
        - opensc-win64          # also install the 64-bit package
{%- endif %}
