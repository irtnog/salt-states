cygwin:
  cmd.script:
    - source: https://cygwin.com/setup-x86_64.exe
    - name: cmd -f -d -q -g -s http://cygwin.mirrors.pair.com/ -O -M All
    - cwd: {{ salt.environ.get('TMP')|yaml_encode }}
