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

{%- for name, settings in salt.pillar.get('winvpn_profiles')|dictsort %}

winvpn_profile_{{ loop.index }}:
  cmd.run:
    - shell: powershell
    - name:
        ("{{ name }}" -in (Get-VpnConnection -AllUserConnection | foreach {$_.Name})) -or
        Add-VpnConnection -Name {{ name }} -Force
{%-   for kwarg, val in settings|dictsort %}
{%-     if val is sameas True or val is sameas False %}
          -{{ kwarg }}:${{ "true" if val else "false"}}
{%-     elif kwarg|lower in ['eapconfigxmlstream', 'cimsession', 'machinecertificateekufilter', 'machinecertificateissuerfilter', 'serverlist'] %}
{#- TODO #}
{%-     elif kwarg|lower in ['tunneltype', 'encryptionlevel', 'authenticationmethod'] %}
          -{{ kwarg }} {{ val }}
{%-     else %}
          -{{ kwarg }} "{{ val }}"
{%-     endif %}
{%-   endfor %}

{%- endfor %}
