#### APACHE/CONTENT/IDP_BRANDING.SLS --- Deploy IdP UI customizations

{%- set idp_hostname = salt['pillar.get']('shibboleth:idp:hostname') %}
{%- set deploy_keyfile = salt['pillar.get']('apache:content:idp_branding:deploy_keyfile') %}

idp_branding:
  git.latest:
    - name: git@github.com:irtnog/{{ idp_hostname }}.git
    - target: /opt/rh/httpd24/root/var/www/443-{{ idp_hostname }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - identity:
        - {{ deploy_keyfile }}

#### APACHE/CONTENT/IDP_BRANDING.SLS ends here.
