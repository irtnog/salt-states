synergy:
  pkg.latest:
{%- if grains['os_family'] in ['Debian', 'RedHat', 'MacOS'] %}
    - sources:
        - synergy: {{ salt['grains.filter_by']({
            'CentOS':   'salt://synergy/dist/synergy-2.0.12-1710.beta.0b61673b.el7.centos.x86_64.rpm',
            'Debian':   'salt://synergy/dist/synergy_2.0.12.beta~b74+0b61673b_amd64.deb',
            'Fedora':   'salt://synergy/dist/synergy-2.0.12-1710.beta.0b61673b.el7.centos.x86_64.rpm',
            'MacOS':    'salt://synergy/dist/Synergy_v2.0.12-beta_b1807-50472cde.dmg',
            'RedHat':   'salt://synergy/dist/synergy-2.0.12-1710.beta.0b61673b.el7.centos.x86_64.rpm',
            'Raspbian': 'salt://synergy/dist/synergy_2.0.12.beta~b62+0b61673b_armhf.deb',
            'Ubuntu':   'salt://synergy/dist/synergy_2.0.12.beta~b1677+0b61673b_amd64.deb',
          }, grain='os')|yaml_encode }}
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
