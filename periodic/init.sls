daily_clean_disks_enable:
  sysrc.managed:
    - value: "YES"
    - file: /etc/periodic.conf

daily_clean_tmps_enable:
  sysrc.managed:
    - value: "YES"
    - file: /etc/periodic.conf

daily_clean_tmps_ignore:
  sysrc.managed:
    - value: {{ [
        '.X*-lock'
        '.X11-unix'
        '.ICE-unix'
        '.font-unix'
        '.XIM-unix'
        'quota.user'
        'quota.group'
        '.snap'
        '.sujournal',
        'screens',
      ]|join(' ')|yaml_encode }}
    - file: /etc/periodic.conf

daily_scrub_zfs_enable:
  sysrc.managed:
    - value: "YES"
    - file: /etc/periodic.conf

daily_status_pkg_changes_enable:
  sysrc.managed:
    - value: "YES"
    - file: /etc/periodic.conf

daily_status_security_inline:
  sysrc.managed:
    - value: "YES"
    - file: /etc/periodic.conf

daily_status_zfs_enable:
  sysrc.managed:
    - value: "YES"
    - file: /etc/periodic.conf

weekly_catman_enable:
  sysrc.managed:
    - value: "YES"
    - file: /etc/periodic.conf

weekly_noid_enable:
  sysrc.managed:
    - value: "YES"
    - file: /etc/periodic.conf

weekly_status_pkg_enable:
  sysrc.managed:
    - value: "YES"
    - file: /etc/periodic.conf

weekly_status_security_inline:
  sysrc.managed:
    - value: "YES"
    - file: /etc/periodic.conf

monthly_status_security_inline:
  sysrc.managed:
    - value: "YES"
    - file: /etc/periodic.conf

security_status_chkportsum_enable:
  sysrc.managed:
    - value: "YES"
    - file: /etc/periodic.conf
