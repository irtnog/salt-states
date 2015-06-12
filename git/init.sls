{% if git_settings.packages is iterable %}
git:
  pkg.installed:
    - pkgs:
      {% for package in git_settings.packages %}
      - {{ package }}
      {% endfor %}
{% endif %}
