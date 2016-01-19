{% from "amavisd/map.jinja" import amavisd_settings with context %}

amavisd:
  pkg.installed:
    - pkgs: {{ amavisd_settings.packages|yaml }}
  file.managed:
    - name: {{ amavisd_settings.conffile }}
    - source: salt://amavisd/files/amavisd.conf.jinja
    - template: jinja
    - user: root
    - group: 0
    - mode: 400
  service.running:
    - names: {{ amavisd_settings.services|yaml }}
    - enable: True
    - require:
        - cmd: sa-update
    - watch:
        - pkg: amavisd
        - file: amavisd

sa-update:
  cron.present:
    - identifier: sa-update
    - name: 'env PATH="${PATH}:/usr/local/bin:/usr/local/sbin" chronic sa-update'
    - minute: random
    - hour: random
    - require:
        - pkg: amavisd
        - file: amavisd
  cmd.wait:
    - watch:
        - cron: sa-update

{% if amavisd_settings.dkim %}
dkim:
  file.managed:
    - name: /var/db/dkim/dkim.key
    - contents: {{ amavisd_settings.dkim|yaml_encode }}
    - user: root
    - group: 0
    - mode: 600
    - makedirs: True
    - dir_mode: 700
{% endif %}
