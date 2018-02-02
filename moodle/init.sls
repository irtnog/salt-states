{%- set install_dir = salt['pillar.get']('moodle:install_dir') %}

moodle:
  git.latest:
    - name: git://git.moodle.org/moodle.git
    - branch: MOODLE_34_STABLE
    - target: {{ install_dir|yaml }}

  file.recurse:
    - name: {{ install_dir|yaml }}
    - source: salt://moodle/files
    - template: jinja
    - require:
        - git: moodle

  selinux.boolean:
    - names:
        - httpd_can_network_connect_db
    - value: True
    - persist: True

  cmd.run:
    - name: scl enable httpd24 rh-php71 -- php install_database.php --agree-license
    - cwd: {{ install_dir }}/admin/cli
    - user: apache
    - onchanges:
        - git: moodle
        - file: moodle
    - require:
        - selinux: moodle
        - selinux: moodle_data

moodle_data_policy:
  selinux.fcontext_policy_present:
    - name: '/var/lib/moodle(/.)?'
    - sel_type: httpd_sys_rw_content_t

moodle_data:
  file.directory:
    - name: /var/lib/moodle
    - user: apache

  selinux.fcontext_policy_applied:
    - name: /var/lib/moodle
    - recursive: True
    - onchanges:
        - file: moodle_data
        - selinux: moodle_data_policy
