{% from "saltpad/map.jinja" import saltpad_settings with context %}

saltpad:
  pkg.installed:
    - pkgs: {{ saltpad_settings.packages|yaml }}
  git.latest:
    - name: {{ saltpad_settings.git_repo }}
    - target: {{ saltpad_settings.prefix }}
