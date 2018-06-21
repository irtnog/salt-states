#### FIRSTRUN.SLS --- Salt Reactor PoC for "salt-key accepted" events

### This formula runs a highstate job on a minion immediately after
### accepting its key on the master.

{%- if data['act'] == 'accept' %}

highstate_new_minion:
  local.state.highstate:
    - tgt: {{ data['id'] }}

{%- endif %}

#### FIRSTRUN.SLS ends here.
