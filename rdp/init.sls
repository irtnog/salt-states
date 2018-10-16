{%- if salt['grains.get']('osversion').split('.')[0] >= 6 %}

## only supported on Windows Server 2008 or newer
remote-desktop:
  rdp.enabled: []

{%-   set certfp = salt['pillar.get']('rdp:listener_cert', False) %}
{%-   if certfp %}

  cmd.run:
    - name: |
        wmic /namespace:\\root\cimv2\TerminalServices PATH Win32_TSGeneralSetting Set SSLCertificateSHA1Hash="{{ certfp }}"

{%-   endif %}

{%- endif %}
