#### NETDOM/JOIN.SLS --- Join an AD domain using netdom.exe

{%- set join = salt['pillar.get']('netdom:join', {}) %}
{%- if join %}

netdom_join:
  system.join_domain:
    - name: {{ join['domain']|yaml_encode }}
    - account_ou: {{ join['ou']|yaml_encode }}
    - username: {{ join['user']|yaml_encode }}
    - password: {{ join['password']|yaml_encode }}
    - account_exists: True

netdom_join_reboot:
  system.reboot:
    - onchanges:
        - system: netdom_join
    - order: last

{%- endif %}

#### NETDOM/JOIN.SLS ends here.
