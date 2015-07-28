{% if grains['os_family'] == 'FreeBSD' %}

create_periodic_conf:
  cmd.run:
    - name: touch /etc/periodic.conf
    - onlyif: test ! -f /etc/periodic.conf

periodic_conf:
  file.blockreplace:
    - name: /etc/periodic.conf
    - append_if_not_found: True
    - backup: False
    - require:
      - cmd: create_periodic_conf

periodic_conf_general_settings:
  file.accumulated:
    - name: periodic_conf_accumulator
    - filename: /etc/periodic.conf
    - text: |
        daily_clean_disks_enable="YES"
        daily_clean_tmps_enable="YES"
        daily_clean_tmps_ignore="${daily_clean_tmps_ignore} screens"
        daily_scrub_zfs_enable="YES"
        daily_status_pkg_changes_enable="YES"
        daily_status_security_inline="YES"
        daily_status_zfs_enable="YES"
        weekly_catman_enable="YES"
        weekly_noid_enable="YES"
        weekly_status_pkg_enable="YES"
        weekly_status_security_inline="YES"
        monthly_status_security_inline="YES"
        security_status_chkportsum_enable="YES"
    - require_in:
      - file: periodic_conf

{% endif %}
