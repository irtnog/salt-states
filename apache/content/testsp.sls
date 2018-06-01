#### APACHE/CONTENT/TESTSP.SLS --- Deploy the test SP web app

{%- set deploy_keyfile = salt['pillar.get']('apache:content:testsp:deploy_keyfile') %}

apache_contest_testsp:
  git.latest:
    - name: git@github.com:irtnog/testsp.irtnog.org.git
    - target: /usr/local/www/apache24/443-testsp.irtnog.org
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - identity:
        - {{ deploy_keyfile }}

#### APACHE/CONTENT/TESTSP.SLS ends here.
