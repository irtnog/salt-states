{%- set pfx_password = salt['pillar.get']('wincert_pfx_password', '') %}
{%- for name, pfx in salt['pillar.get']('wincert', {})|dictsort %}
{%- set state_id = 'windows_import_cert_%s'|format(name) %}
{{ state_id|yaml_encode }}:
  file.managed:
    - name: {{ 'c:\\salt\\var\\win-certstore\\%s.pfx'|format(name)|yaml_encode }}
    - source: salt://wincert/files/wincert.pfx
    - template: jinja
    - context:
        pfx: {{ pfx|yaml_encode }}
    - makedirs: True
    - win_owner: Administrators
    - win_perms:
        Administrators:
          perms: full_control

  cmd.run:
    - name: {{ 'certutil -csp "Microsoft Enhanced RSA and AES Cryptographic Provider" -p %s -importpfx c:\\salt\\var\\win-certstore\\%s.pfx'|format(pfx_password, name)|yaml_encode }}
    - onchanges:
        - file: {{ state_id|yaml_encode }}
{%- endfor %}
