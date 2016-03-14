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
    - require:
        - git: saltpad

saltpad_wsgi:
  file.managed:
    - name: {{ saltpad_settings.prefix }}/saltpad.wsgi
    - source: salt://saltpad/files/saltpad.wsgi.jinja
    - template: jinja
    - user: {{ saltpad_settings.user }}
    - group: {{ saltpad_settings.group }}
    - mode: 644
    - require:
        - git: saltpad

saltpad_log_file:
  file.managed:
    - name: {{ saltpad_settings.log_file }}
    - user: {{ saltpad_settings.user }}
    - group: {{ saltpad_settings.group }}
    - mode: 640