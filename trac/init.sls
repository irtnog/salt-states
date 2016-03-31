{% from "trac/map.jinja" import trac_settings with context %}

trac:
  pkg.installed:
    - pkgs: {{ trac_settings.packages|yaml }}

  group.present:
    - name: {{ trac_settings.group }}
    - gid: {{ trac_settings.gid }}
    - system: True

  user.present:
    - name: {{ trac_settings.user }}
    - home: {{ trac_settings.prefix|yaml_encode }}
    - uid: {{ trac_settings.uid }}
    - gid: trac
    - system: True
    - require:
        - group: trac

  cmd.run:
    - names:
        {% for env in trac_settings.environments %}
        {% set path = "%s%s"|format(trac_settings.prefix, env.id) %}
        {% set name = env.name %}
        {% set db = env.db|default('sqlite:db/trac.db') %}
        - {{ "if [ ! -d '%s' ]; then trac-admin '%s' initenv '%s' '%s'; fi"|format(path, path, name, db)|yaml_encode }}
        {% else %}
        []
        {% endfor %}
    - user: {{ trac_settings.user }}
    - shell: /bin/sh
    - cwd: {{ trac_settings.prefix|yaml_encode }}
    - umask: '0026'
    - require:
        - pkg: trac
        - user: trac

  file.recurse:
    - name: {{ trac_settings.prefix|yaml_encode }}
    - source: salt://trac/files/
    - template: jinja
    - user: {{ trac_settings.user }}
    - group: {{ trac_settings.group }}
    - dir_mode: 751
    - file_mode: 640
    - require:
        - cmd: trac
