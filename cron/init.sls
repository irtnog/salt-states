{% from "cron/map.jinja" import cron_settings with context %}

cron:
  pkg.installed:
    - pkgs: {{ cron_settings.packages|yaml }}

  service.running:
    - names: {{ cron_settings.services|yaml }}
    - enable: True
    - watch:
        - pkg: cron

{% if grains['os_family'] == 'FreeBSD' %}
crontab_enable_local_path:
  file.replace:
    - name: /etc/crontab
    - pattern: '^(PATH=((?!/usr/local/bin:/usr/local/sbin).)*)$'
    - repl: '\1:/usr/local/bin:/usr/local/sbin'
    - backup: False

/usr/sbin/freebsd-update cron:
  cron.present:
    - identifier: freebsd-update
    - user: root
    - minute: random
    - hour: random

/usr/sbin/portsnap cron:
  cron.present:
    - identifier: portsnap
    - user: root
    - minute: random
    - hour: random
{% endif %}
