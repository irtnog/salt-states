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
    - names:
        - {{ 'certutil -decode -f c:\\salt\\var\\win-certstore\\%s.pfx.b64 c:\\salt\\var\\win-certstore\\%s.pfx'|format(name, name)|yaml_encode }}
        - {{ 'certutil -p %s -importpfx c:\\salt\\var\\win-certstore\\%s.pfx'|format(pfx_password, name)|yaml_encode }}
    - onchanges:
        - file: {{ state_id|yaml_encode }}
{%- endfor %}