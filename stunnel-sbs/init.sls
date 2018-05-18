stunnel_sbs:
  service.running:
    - name: stunnel
    - enable: True

{%- for name, keymat in salt['pillar.get']('stunnel-sbs:certificates', {}) %}

stunnel_sbs_{{ name }}:
  file.managed:
    - name: {{ [
        salt['environ.get']('ProgramFiles(x86)') if salt['grains.get']('cpuarch') == 'AMD64' else
        salt['environ.get']('ProgramFiles'),
        'stunnel',
        name ~ '.pem'
      ]|join('\\')|yaml_encode }}
    - contents: {{ keymat|yaml_encode }}
    - win_owner: Administrators
    - win_perms:
        Administrators:
          perms: full_control
    - watch_in:
        - service: stunnel_sbs

{%- endfor %}
