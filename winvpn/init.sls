## This configures Windows so that it can initiate IPsec-secured
## communications when both the initiators and the responders are
## behind network address translators;
## cf. https://support.microsoft.com/en-us/help/885407.
winvpn_restore_orig_nat_behavior:
  reg.present:
    - name: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PolicyAgent
    - vname: AssumeUDPEncapsulationContextOnSendRule
    - vdata: 2                  # both endpoints may be behind NAT
    - vtype: REG_DWORD

{%- set osversion_major = salt['grains.get']('osversion').split('.')[0] %}
{%- set osversion_minor = salt['grains.get']('osversion').split('.')[1] %}
{%- if osversion_major > 6 or (osversion_major == 6 and osversion_minor == 3) %}
{%-   for name, settings in salt['pillar.get']('winvpn_profiles')|dictsort %}

winvpn_profile_{{ loop.index }}:
  cmd.run:
    - shell: powershell
    - unless:
        ((Get-VpnConnection -AllUserConnection | foreach {$_.Name}) -contains "{{ name }}")
        -or [Environment]::Exit(1)
    - name:
        Add-VpnConnection -Name {{ name }} -AllUserConnection -Force
{%-     for kwarg, val in settings|dictsort %}
{%-       if val is sameas True or val is sameas False %}
          -{{ kwarg }}:${{ "true" if val else "false"}}
{%-       elif kwarg|lower in ['eapconfigxmlstream', 'cimsession', 'machinecertificateekufilter', 'machinecertificateissuerfilter', 'serverlist'] %}
{#- TODO #}
{%-       elif kwarg|lower in ['tunneltype', 'encryptionlevel', 'authenticationmethod'] %}
          -{{ kwarg }} {{ val }}
{%-       elif val is string %}
          -{{ kwarg }} '{{ val }}'
{%-       else %}
          -{{ kwarg }} {{ val }}
{%-       endif %}
{%-     endfor %}

{%-   endfor %}
{%- endif %}
