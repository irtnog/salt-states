{% from "cron/map.jinja" import cron with context %}
{% if cron %}

cron:
  {% if cron.packages %}
  pkg:
    - installed
    - pkgs:
      {% for package in cron.packages %}
      - {{ package }}
      {% endfor %}
    - require:
      - module: update_repos
  {% else %}
  []
  {% endif %}

{% if grains['os_family'] == 'FreeBSD' %}
crontab_enable_local_path:
  file:
    - replace
    - name: /etc/crontab
    - pattern: '^(PATH=((?!/usr/local/bin:/usr/local/sbin).)*)$'
    - repl: '\1:/usr/local/bin:/usr/local/sbin'
    - backup: False

/usr/sbin/freebsd-update cron:
  cron:
    - present
    - identifier: freebsd-update
    - user: root
    - minute: random
    - hour: random

/usr/sbin/portsnap cron:
  cron:
    - present
    - identifier: portsnap
    - user: root
    - minute: random
    - hour: random
{% endif %}

{% endif %}
