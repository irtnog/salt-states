{% from "amavisd/map.jinja" import amavisd_settings with context %}

amavisd:
  pkg.installed:
    - pkgs: {{ amavsid_settings.packages|yaml }}
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
    - watch:
        - pkg: amavisd
        - file: amavisd

sa-update:
  cmd.wait:
    - watch:
        - pkg: amavisd
        - file: amavisd
  cron.present:
    - identifier: sa-update
    - name: 'env PATH="${PATH}:/usr/local/bin:/usr/local/sbin" chronic sa-update'
    - minute: random
    - hour: random
    - require:
        - pkg: amavisd
        - file: amavisd
