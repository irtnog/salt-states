include:
  - apache
  - satosa

extend:
  satosa:
    pkg: &satosa-apache-restart
      - watch_in:
          - module: apache-restart
    virtualenv: *satosa-apache-restart
    selinux: *satosa-apache-restart
    file: *satosa-apache-restart
    git: *satosa-apache-restart

  satosa_logs:
    file: *satosa-apache-restart
