{% from "postfix/map.jinja" import postfix_settings with context %}

postfix:
  {% if postfix_settings.packages is iterable %}
  pkg.installed:
    - pkgs:
      {% for package in postfix_settings.packages %}
      - {{ package }}
      {% endfor %}
    - require_in:
      - file: postfix_main.cf
      - file: postfix_master.cf
    - watch_in:
      - service: postfix
  {% endif %}
  service.running:
    - name: {{ postfix_settings.service }}
    - enable: True
    - watch:
      - file: postfix_main.cf
      - file: postfix_master.cf

postfix_main.cf:
  file.blockreplace:
    - name: {{ postfix_settings.prefix }}/etc/postfix/main.cf
    - append_if_not_found: True
    - content: |
        {% for entry in postfix_settings.main -%}
        {% if entry is mapping -%}
        {% for key, value in entry.items() -%}
        {% if value is string or value is number -%}
        {{ key }} = {{ value }}
        {% elif value is sameas true or value is sameas false -%}
        {{ key }} = {{ "yes" if value else "no" }}
        {% elif value is iterable -%}
        {{ key }} = {{ value | join(', ') }}
        {% endif -%}
        {% endfor -%}
        {% else -%}
        {{ entry }}
        {% endif -%}
        {% else -%}
        ## Nothing to see here.  Move along.
        {%- endfor %}

postfix_master.cf:
  file.blockreplace:
    - name: {{ postfix_settings.prefix }}/etc/postfix/master.cf
    - append_if_not_found: True
    - content: |
        {% for entry in postfix_settings.master %}
        {{ entry }}
        {% else %}
        ## Nothing to see here.  Move along.
        {% endfor %}

{% for type, maps in postfix_settings.maps.items() %}
{% for map, entries in maps.items() %}
postmap_{{ type }}_{{ map }}:
  file.managed:
    - name: {{ postfix_settings.prefix }}/etc/postfix/{{ map }}
    - content: |
        {% for entry in entries %}
        {% if entry is mapping %}
        {% for key, value in entry.items() %}
        {% if value is string or value is number %}
        {{ key }} = {{ value }}
        {% elif value is sameas true or value is sameas false %}
        {{ key }} = {{ "yes" if value else "no" }}
        {% elif value is iterable %}
        {{ key }} = {{ value | join(', ') }}
        {% endif %}
        {% endfor %}
        {% else %}
        {{ entry }}
        {% endif %}
        {% else %}
        ## Nothing to see here.  Move along.
        {% endfor %}
    - user: root
    - group: 0
    - mode: 640
    - require:
      - file: postfix_main.cf
  {% if type in ['btree', 'cdb', 'dbm', 'hash', 'fail', 'sdbm'] %}
  cmd.wait:
    - name: postmap {{ type }}:{{ postfix_settings.prefix }}/etc/postfix/{{ map }}
    - watch:
      - file: postmap_{{ type }}_{{ map }}
  {% endif %}
    - require_in:
      - service: postfix
{% endfor %}
{% endfor %}

{% if salt['grains.get']('os_family') == 'FreeBSD' %}
postfix_mailer.conf:
  file.managed:
    - name: /etc/mail/mailer.conf
    - user: root
    - group: 0
    - mode: 444
    - content: |
        sendmail   /usr/local/sbin/sendmail
        send-mail  /usr/local/sbin/sendmail
        mailq      /usr/local/sbin/sendmail
        newaliases /usr/local/sbin/sendmail
    - require:
      - file: postfix_main.cf
    - require_in:
      - service: postfix
{% endif %}
