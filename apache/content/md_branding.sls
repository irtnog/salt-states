#### APACHE/CONTENT/MD_BRANDING.SLS --- Deploy MD UI customizations

{%- set md_hostname = salt.pillar.get('apache:content:md_branding:hostname') %}
{%- set deploy_keyfile = salt.pillar.get('apache:content:md_branding:deploy_keyfile') %}

md_branding:
  git.latest:
    - name: git@github.com:irtnog/{{ md_hostname }}.git
    - target: /opt/rh/httpd24/root/var/www/443-{{ md_hostname }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - identity:
        - {{ deploy_keyfile }}

#### APACHE/CONTENT/MD_BRANDING.SLS ends here.
