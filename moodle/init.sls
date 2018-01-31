{%- set install_dir = salt['pillar.get']('moodle:install_dir') %}

moodle:
  git.latest:
    - name: git://git.moodle.org/moodle.git
    - branch: MOODLE_34_STABLE
    - target: {{ install_dir|yaml }}

moodle_selinux_booleans:
  selinux.boolean:
    - names:
        - httpd_can_network_connect_db
    - value: True
    - persist: True

moodle_data:
  file.directory:
    - name: /var/lib/moodle
    - user: apache

moodle_data_selinux_fcontext_policy:
  selinux.fcontext_policy_present:
    - name: '/var/lib/moodle(/.)?'
    - sel_type: httpd_sys_rw_content_t

moodle_data_selinux_fcontext_policy_applied:
  selinux.fcontext_policy_applied:
    - name: /var/lib/moodle
    - recursive: True
    - onchanges:
        - file: moodle_data
    - require:
        - selinux: moodle_data_selinux_fcontext_policy
