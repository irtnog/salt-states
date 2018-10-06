#### CERTBOT-DEPLOY.SLS --- Deploy renewed Let's Encrypt certificates

### This sends highstate jobs to minions based on a Pillar key named
### after the event tag.  This makes it possible to control all
### certificate-related actions (issuance, deployment, and renewal)
### via Pillar.  Results get reported to the sysadmins via the
### certbot.highstate returner.

certbot_deploy:
  local.state.apply:
    - tgt: {{ tag }}:*
    - tgt_type: pillar
    - return: highstate
    - return_config: certbot

#### CERTBOT-DEPLOY.SLS ends here.
