#### CERTBOT-DEPLOY.SLS --- Deploy renewed Let's Encrypt certificates

### This deploys updated key-pairs by mapping the event tag to a
### target/SLS pair.  As this scales up, use the list of domains in
### the renewed certificate to further scope the target specification.

{%- set domains = data['data']['domains']|default([]) %}

certbot_deploy:
  local.state.apply:
    - kwarg:
        saltenv: production

{%- if tag in [ 'certbot/deploy/companyweb'
              , 'certbot/deploy/mail'
              , 'certbot/deploy/sbs'
              ] %}

    - tgt: I@role:sbs
    - tgt_type: compound
    - arg:
        - wincert
        - iis.bindings
        - rdp
        - stunnel-sbs

{%- elif tag == 'certbot/deploy/minecraft' %}

    - tgt: I@role:minecraft
    - tgt_type: compound
    - arg: [apache.certificates]

{%- elif tag == 'certbot/deploy/mooc' %}

    - tgt: I@role:training
    - tgt_type: compound
    - arg: [apache.certificates]

{%- elif tag in [ 'certbot/deploy/mx1'
                , 'certbot/deploy/mx2'
                ] %}

    - tgt: I@role:mail-relay
    - tgt_type: compound
    - arg: [postfix]

{%- elif tag in [ 'certbot/deploy/openid'
                , 'certbot/deploy/proconsul'
                , 'certbot/deploy/pwreset'
                , 'certbot/deploy/satosa'
                , 'certbot/deploy/samlidp'
                , 'certbot/deploy/samlmdq'
                ] %}

    - tgt: I@role:identity-provider
    - tgt_type: compound
    - arg: [apache.certificates]

{%- elif tag in [ 'certbot/deploy/ra'
                , 'certbot/deploy/svr'
                ] %}

    - tgt: I@role:svr
    - tgt_type: compound
    - arg:
        - wincert
        - iis.bindings
        - rdp

{%- elif tag in [ 'certbot/deploy/pkg'
                , 'certbot/deploy/salt'
                ] %}

    - tgt: I@role:nas
    - arg: [apache.certificates]

{%- elif tag in [ 'certbot/deploy/testsp'
                , 'certbot/deploy/www'
                ] %}

    - tgt: I@role:web-server
    - arg: [apache.certificates]

{%- endif %}

#### CERTBOT-DEPLOY.SLS ends here.
