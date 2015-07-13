{% from "git/map.jinja" import git_settings with context %}

git:
  pkg.installed:
    - pkgs: {{ git_settings.packages|yaml }}
