stunnel_sbs:
  module.wait:
    - name: cmd.run
    - m_name: net stop stunnel && net start stunnel

{%- for name, keymat in salt['pillar.get']('stunnel-sbs:certificates', {})|dictsort %}

stunnel_sbs_{{ name }}:
  file.managed:
    - name: {{ [
        salt['environ.get']('ProgramFiles(x86)') if salt['grains.get']('cpuarch') == 'AMD64' else
        salt['environ.get']('ProgramFiles'),
        'stunnel',
        'config',
        name ~ '.pem'
      ]|join('\\')|yaml_encode }}
    - contents: {{ keymat|yaml_encode }}
    - win_owner: Administrators
    - win_perms:
        Administrators:
          perms: full_control
    - watch_in:
        - module: stunnel_sbs

{%- endfor %}
