{% from "webhooks/map.jinja" import webhooks_settings with context %}

webhooks:
  pkg.installed:
    - pkgs: {{ webhooks_settings.packages|yaml }}
  git.latest:
    - name: {{ webhooks_settings.git_repo }}
    - target: {{ webhooks_settings.prefix }}
  file.managed:
    - name: {{ webhooks_settings.prefix }}/config.json
    - source: salt://webhooks/files/config.json.jinja
    - template: jinja
    - user: {{ webhooks_settings.user }}
    - group: {{ webhooks_settings.group }}
    - mode: 400
    - require:
        - git: webhooks

webhooks_hooks:
  file.recurse:
    - name: {{ webhooks_settings.prefix }}/hooks
    - source: salt://webhooks/files/hooks
    - clean: True
    - dir_mode: 755
    - file_mode: 700            # scripts might contain sensitive data
    - template: jinja
    - maxdepth: 0               # only files located in the source dir
    - user: {{ webhooks_settings.user }}
    - group: {{ webhooks_settings.group }}
    - require:
        - git: webhooks
