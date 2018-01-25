{%- from "eclipse/map.jinja" import eclipse with context %}

eclipse:
  file.directory:
    - name: {{ eclipse.prefix|yaml_encode }}
    - makedirs: True

  archive.extracted:
    - name: {{ eclipse.prefix|yaml_encode }}
    - source: {{ eclipse.source_template|format(
        eclipse.codename,
        eclipse.point,
        eclipse.tasksel,
        eclipse.codename,
        eclipse.point,
        eclipse.bdist,
        eclipse.suffix
      )|yaml_encode }}
    - source_hash: {{ eclipse.source_template|format(
        eclipse.codename,
        eclipse.point,
        eclipse.tasksel,
        eclipse.codename,
        eclipse.point,
        eclipse.bdist,
        eclipse.suffix ~ '.' ~ eclipse.checksum
      )|yaml_encode }}
{%- if eclipse.suffix == 'zip' %}
    - archive_format: zip
    - extract_perms: False
{%- else %}
    - archive_format: tar
{%- endif %}
    - require:
        - file: eclipse

{%- if salt['grains.get']('os_family') == 'Windows' %}

## Launch Eclipse from %ProgramFiles% while pointing %ECLIPSEDIR% to
## the user's local (non-roaming) application data folder.
eclipse_bat:
  file.managed:
    - name: &eclipse-bat {{
        [ eclipse.prefix
        , 'eclipse.bat'
        ]|join('\\')|yaml_encode
      }}
    - source: salt://eclipse/files/eclipse.bat
    - template: jinja
    - context:
        prefix: {{ eclipse.prefix|yaml_encode }}
        version: {{ eclipse.version|yaml_encode }}
        point: {{ eclipse.point|yaml_encode }}
    - require:
        - file: eclipse

## Create a Start Menu shortcut to the above batch file.
eclipse_shortcut:
  file.shortcut:
    - name: {{
        [ salt['environ.get']('ALLUSERSPROFILE')
        , 'Start Menu'
        , 'Programs'
        , 'Eclipse ' ~ eclipse.version ~ '.' ~ eclipse.point ~ '.lnk'
        ]|join('\\')|yaml_encode
      }}
    - target: *eclipse-bat
    - icon_location: {{
        [ eclipse.prefix
        , 'eclipse'
        , 'eclipse.exe'
        ]|join('\\')|yaml_encode
      }}
    - require:
        - archive: eclipse
        - file: eclipse_bat

{%- endif %}
