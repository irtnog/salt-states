cygwin:
  cmd.script:
    - source: https://cygwin.com/setup-x86_64.exe
    - name: cmd -D -f -d -q -g
    - cwd: {{ salt.environ.get('TMP')|yaml_encode }}
