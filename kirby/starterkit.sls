## FIXME: RHEL-specific

kirby_starterkit:
  pkg.installed:
    - pkgs:
        - php
        - php-mbstring
  file.directory:
    - name: /var/www/html
    - user: apache
    - group: apache
    - dir_mode: 755
    - file_mode: 644
    - recurse:
        - user
        - group
        - mode
  git.latest:
    - name: https://github.com/getkirby/starterkit.git
    - target: /var/www/html
    - submodules: True
    - user: apache
    - require:
        - file: kirby_starterkit
  cmd.run:
    - names:
        - chcon -R -t httpd_sys_rw_content_t /var/www/html/site/accounts
        - chcon -R -t httpd_sys_rw_content_t /var/www/html/thumbs
        - chcon -R -t httpd_sys_rw_content_t /var/www/html/content
        - chcon -R -t httpd_sys_rw_content_t /var/www/html/assets/avatars
    - require:
        - git: kirby_starterkit
