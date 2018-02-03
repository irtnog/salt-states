{%- from "moodle/map.jinja" import moodle with context %}
{%- set selinux_active = 'selinux' in salt['sys.list_modules']()
      and salt['selinux.getenforce']() == 'Enforcing' %}

moodle:
  git.latest:
    - name: git://git.moodle.org/moodle.git
    - branch: MOODLE_34_STABLE
    - target: {{ moodle.prefix|yaml_encode }}

  file.recurse:
    - name: {{ moodle.prefix|yaml }}
    - source: salt://moodle/files
    - template: jinja
    - require:
        - git: moodle

  cmd.run:
    - name: {{ moodle.php_cmd }} install_database.php --agree-license
    - cwd: {{
        [ moodle.prefix
        , "admin"
        , "cli"
        ]|join(moodle.dirsep)|yaml_encode
      }}
    - user: apache
    - onchanges:
        - git: moodle
        - file: moodle

moodle_data:
  file.directory:
    - name: {{ moodle.config.dataroot|yaml_encode }}
    - user: apache

{%- if selinux_active %}

  selinux.fcontext_policy_applied:
    - name: {{ moodle.config.dataroot|yaml_encode }}
    - recursive: True
    - onchanges:
        - file: moodle_data
        - selinux: moodle_data_policy
    - require_in:
        - cmd: moodle

moodle_data_policy:
  selinux.fcontext_policy_present:
    - name: {{ '%s(/.)?'|format(moodle.config.dataroot)|yaml_encode }}
    - sel_type: httpd_sys_rw_content_t
    - require_in:
        - cmd: moodle

moodle_selinux_booleans:
  selinux.boolean:
    - names:
        - httpd_can_network_connect_db
    - value: True
    - persist: True
    - require_in:
        - cmd: moodle

{%- endif %}
