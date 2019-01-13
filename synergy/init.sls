synergy:
  pkg.installed:
{%- if grains['os_family'] == 'Debian' %}
    - sources:
        - synergy:
            salt://synergy/dist/synergy_1.10.1.stable_b87+8941241e_{{ grains['os']|lower }}_{{ grains['osarch']|lower }}.deb
{%- else %}
    []
{%- endif %}

{%- if grains['os_family'] == 'Windows' %}

synergy_power_request_override:
  reg.present:
    - name:
        HKLM\SYSTEM\CurrentControlSet\Power\PowerRequestOverride\Process
    - vname:
        synergyc.exe
    - vtype:
        REG_DWORD
    - vdata:
        3                       # DISPLAY, SYSTEM

{%- endif %}
