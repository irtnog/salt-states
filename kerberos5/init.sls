{% from "kerberos5/map.jinja" import kerberos5_settings with context %}

kerberos5:
  pkg.installed:
    - pkgs: {{ kerberos5_settings.packages|yaml }}
  file.managed:
    - name: /etc/krb5.conf
    - source: salt://kerberos5/files/krb5.conf.jinja
    - template: jinja
    - user: root
    - group: 0
    - mode: 444
    - require:
        - pkg: kerberos5

{% if grains['os_family'] == 'FreeBSD' %}

{% for file in ['ftp', 'imap', 'other', 'pop3', 'sshd', 'system', 'telnetd', 'xdm'] %}
pam_service_{{ file }}:
  file.replace:
    - name: /etc/pam.d/{{ file }}
    - pattern: '#(.*pam_krb5.*)'
    - repl: '\1'
    - backup: False
{% endfor %}

pam_service_ftpd:
  cmd.wait:
    - name: ln -f /etc/pam.d/ftp /etc/pam.d/ftpd
    - watch:
        - file: pam_service_ftp

{% elif grains['os_family'] == 'RedHat' %}

kerberos5_authconfig:
  file.replace:
    - name: /etc/sysconfig/authconfig
    - pattern: ^USEKERBEROS=no
    - repl: USEKERBEROS=yes
    - append_if_not_found: True
    - require:
        - pkg: kerberos5
  cmd.wait:
    - name: authconfig --updateall
    - watch:
        - pkg: kerberos5
        - file: kerberos5
        - file: kerberos5_authconfig

{% elif grains['os_family'] == 'Suse' %}

kerberos5_pam-config:
  cmd.run:
    - name: pam-config -a --krb5 --krb5-ignore_unknown_principals
    - require:
        - pkg: kerberos5

{% endif %}
