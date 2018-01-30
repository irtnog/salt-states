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

moodle_cache:
  file.directory:
    - name: /var/cache/moodle
    - user: apache

moodle_cache_selinux_fcontext_policy:
  selinux.fcontext_policy_present:
    - name: '/var/cache/moodle(/.)?'
    - sel_type: httpd_sys_rw_content_t

moodle_cache_selinux_fcontext_policy_applied:
  selinux.fcontext_policy_applied:
    - name: /var/cache/moodle
    - recursive: True
    - onchanges:
        - file: moodle_cache
    - require:
        - selinux: moodle_cache_selinux_fcontext_policy
