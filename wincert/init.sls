{#- Specify the CSP on Windows 8/Windows Server 2012 and newer. #}
{%- set osversion = salt['grains.get']('osversion').split('.') %}
{%- set osvermajor = osversion[0]|int %}
{%- set osverminor = osversion[1]|int %}
{%- if osvermajor > 6 or (osvermajor == 6 and osverminor > 1) %}
{%-   set csp = ' -csp "Microsoft Enhanced RSA and AES Cryptographic Provider"' %}
{%- else %}
{%-   set csp = '' %}
{%- endif %}

{%- set pfx_password = salt['pillar.get']('wincert_pfx_password', '') %}
{%- for name, pfx in salt['pillar.get']('wincert', {})|dictsort %}
{%- set state_id = 'windows_import_cert_%s'|format(name) %}
{{ state_id|yaml_encode }}:
  file.managed:
    - name: {{ 'c:\\salt\\var\\win-certstore\\%s.pfx.b64'|format(name)|yaml_encode }}
    - contents: {{ pfx|yaml_encode }}
    - makedirs: True
    - win_owner: Administrators
    - win_perms:
        Administrators:
          perms: full_control

  cmd.run:
    - name:
        {{ 'certutil -decode -f c:\\salt\\var\\win-certstore\\%s.pfx.b64 c:\\salt\\var\\win-certstore\\%s.pfx && certutil%s -p %s -importpfx c:\\salt\\var\\win-certstore\\%s.pfx'|format(name, name, csp, pfx_password, name)|yaml_encode }}
    - onchanges:
        - file: {{ state_id|yaml_encode }}
{%- endfor %}
