# TODO: /etc/krb5.conf?
# FIXME: kerberos client operation when the Internet link is down?

{% from "pam_krb5/map.jinja" import pam_krb5 with context %}
{% if pam_krb5 %}

{% if pam_krb5.packages %}
pam_krb5:
  pkg:
    - installed
    - pkgs:
      {% for package in pam_krb5.packages %}
      - {{ package }}
      {% endfor %}
    - require:
      - module: update_repos
{% endif %}

{% if grains['os_family'] == 'FreeBSD' %}
{% for file in ['ftp', 'imap', 'other', 'pop3', 'sshd', 'system', 'telnetd', 'xdm'] %}
pam_service_{{ file }}:
  file:
    - replace
    - name: /etc/pam.d/{{ file }}
    - pattern: '#(.*pam_krb5.*)'
    - repl: '\1'
    - backup: False
{% endfor %}

pam_service_ftpd:
  cmd:
    - wait
    - name: ln -f /etc/pam.d/ftp /etc/pam.d/ftpd
    - watch:
      - file: pam_service_ftp
{% endif %}

{% endif %}
