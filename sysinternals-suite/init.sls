sysinternals-suite:
  file.directory:
    - name: &sysinternals-suite {{
        [ salt['environ.get']('ProgramFiles(x86)') if salt['grains.get']('cpuarch') == 'AMD64' else
          salt['environ.get']('ProgramFiles')
        , 'Sysinternals Suite'
        ]|join('\\')|yaml_encode }}

  archive.extracted:
    - name: *sysinternals-suite
    - source:
        https://download.sysinternals.com/files/SysinternalsSuite.zip
    - require:
        - file: sysinternals-suite

  win_path.exists:
    - name: *sysinternals-suite
