openid_ldap:
  ## package install handled by apache-formula in order to ensure that
  ## the httpd service restarts in order to load the module
  ## post-installation; documented here for posterity
  # pkg.installed:
  #   - pkgs:
  #       - php
  #       - php-ldap

  git.latest:
    - name: https://github.com/irtnog/openid-ldap
    - target: /var/www/openid-ldap
    - rev: patch-php42-deprecated-functions
    - force_reset: True         # FIXME

  ## not idempotent as changes to this file get overwritten by git
  ## state above, as OpenID-LDAP doesn't separate code from
  ## configuration
  file.managed:
    - name: /var/www/openid-ldap/ldap.php
    - source: salt://openid-ldap/files/ldap.php
    - template: jinja
    - user: apache
    - group: apache
    - mode: 400
    - require:
        - git: openid_ldap

  ## label the web app directory properly
  cmd.wait:
    - name:
        chcon -R -t httpd_sys_content_t /var/www/openid-ldap
    - watch:
        - git: openid_ldap
        - file: openid_ldap

  ## allow httpd to connect to the domain controllers
  selinux.boolean:
    - name: httpd_can_connect_ldap
    - value: on
