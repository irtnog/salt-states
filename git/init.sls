{% from "git/map.jinja" import git_settings with context %}

{% if git_settings.packages is iterable %}
git:
  pkg.installed:
    - pkgs:
      {% for package in git_settings.packages %}
      - {{ package }}
      {% endfor %}
{% endif %}
