satosa:
  pkg.installed:
    - pkgs:
        - rh-python36-python-virtualenv
        - gcc                   # to compile python-ldap
        - git                   # to install SATOSA, pysaml2 from GitHub
        - xmlsec1-openssl       # for metadata caching
    - reload_modules:
        True

  virtualenv.managed:
    - name:
        /opt/satosa
    - venv_bin:
        /opt/rh/rh-python36/root/usr/bin/virtualenv
    - env_vars:                 # reverse engineered from scl
        MANPATH:
          '/opt/rh/rh-python36/root/usr/share/man:'
        LD_LIBRARY_PATH:
          /opt/rh/rh-python36/root/usr/lib64
        PATH:
          /opt/rh/rh-python36/root/usr/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
        PKG_CONFIG_PATH:
          /opt/rh/rh-python36/root/usr/lib64/pkgconfig
        XDG_DATA_DIRS:
          /opt/rh/rh-python36/root/usr/share:/usr/local/share:/usr/share
    - system_site_packages:
        True
    - pip_upgrade:
        True
    - pip_pkgs:
        - ldap3
        - git+https://github.com/irtnog/SATOSA.git#egg=SATOSA
        - git+https://github.com/irtnog/pysaml2.git#egg=pysaml2
    - require:
        - pkg: satosa

  selinux.boolean:
    - names:
        - httpd_can_connect_ldap
        - httpd_execmem
    - value:
        True
    - persist:
        True

  file.recurse:
    - name:
        /opt/satosa
    - source:
        salt://satosa/files
    - template:
        jinja
    - include_empty:
        yes
    - exclude_pat:
        E@\.gitignore
    - user:
        root
    - group:
        apache
    - dir_mode:
        751
    - file_mode:
        640

  git.latest:
    - name:
        https://github.com/irtnog/satosa_microservices
    - branch:
        master
    - target:
        /opt/satosa_microservices
    - force_reset:
        True
