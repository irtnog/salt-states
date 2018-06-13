remote-desktop:
  rdp.enabled: []

{%- set certfp = salt['pillar.get']('rdp:listener_cert', False) %}
{%- if certfp %}
  cmd.run:
    - name: |
        wmic /namespace:\\root\cimv2\TerminalServices PATH Win32_TSGeneralSetting Set SSLCertificateSHA1Hash="{{ certfp }}"
{%- endif %}
