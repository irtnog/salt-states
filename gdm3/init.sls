gdm3:                           # should already be installed and running
  file.managed:
    - name: /etc/gdm3/greeter.dconf-defaults
    - contents: |
        [org/gnome/login-screen]
        disable-user-list=true

  module.run:
    - name: service.restart
    - m_name: gdm
    - watch:
        - file: gdm3
