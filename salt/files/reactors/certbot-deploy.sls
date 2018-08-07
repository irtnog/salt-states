#### CERTBOT-DEPLOY.SLS --- Deploy renewed Let's Encrypt certificates

### This sends highstate jobs to minions based on a Pillar key named
### after the event tag.  This makes it possible to control all
### certificate-related actions (issuance, deployment, and renewal)
### via Pillar.

{%- set domains = data['data']['domains']|default([]) %}

certbot_deploy:
  local.state.apply:
    - tgt: {{ tag }}:True
    - tgt_type: pillar

#### CERTBOT-DEPLOY.SLS ends here.
