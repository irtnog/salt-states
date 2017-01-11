systemd_journald:
  file.directory:
    - name: /var/log/journal
    - user: root
    - group: root
    - dir_mode: 755

  service.running:
    - name: systemd-journald
    - enable: True
    - watch:
        - file: systemd_journald
