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
    - python:
        /opt/rh/rh-python36/root/usr/bin/python
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
    - pip_upgrade:
        True
    - system_site_packages:
        True
    - pip_pkgs:
        - ldap3
        - git+https://github.com/irtnog/SATOSA.git#egg=SATOSA
        - git+https://github.com/irtnog/pysaml2.git#egg=SATOSA
