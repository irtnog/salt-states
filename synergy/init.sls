synergy:
  pkg.latest:
{%- if grains['os_family'] == 'Debian' %}
    - sources:
        - synergy:
            salt://synergy/dist/synergy_2.0.12.beta~b1677+0b61673b_{{ grains['osarch']|lower }}.deb
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

synergy2_power_request_override:
  reg.present:
    - use:
        - reg: synergy_power_request_override
    - vname:
        synergy-core.exe

{%- endif %}
