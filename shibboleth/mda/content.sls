shibboleth_mda_content:
  file.recurse:
    - name: /var/www/html
    - source: salt://shibboleth/mda/content
    - template: jinja
    - include_empty: yes
    - exclude_pat: E@\.gitignore
    - dir_mode: 755
    - file_mode: 644
