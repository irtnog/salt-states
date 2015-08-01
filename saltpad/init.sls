{% from "saltpad/map.jinja" import saltpad_settings with context %}

saltpad:
  pkg.installed:
    - pkgs: {{ saltpad_settings.packages|yaml }}
  git.latest:
    - name: {{ saltpad_settings.git_repo }}
    - target: {{ saltpad_settings.prefix }}
  file.managed:
    - name: {{ saltpad_settings.prefix }}/saltpad/local_settings.py
    - source: salt://saltpad/files/local_settings.py.jinja
    - template: jinja
    - user: {{ saltpad_settings.user }}
    - group: {{ saltpad_settings.group }}
    - mode: 400
