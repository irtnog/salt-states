include:
  - apache
  - satosa

extend:
  satosa:
    virtualenv: &satosa-apache-restart
      - watch_in:
          - module: apache-restart
    selinux: *satosa-apache-restart
    files: *satosa-apache-restart
    git: *satosa-apache-restart
