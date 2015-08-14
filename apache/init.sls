{% from "apache/map.jinja" import apache_settings with context %}

apache:
  pkg.installed:
    - pkgs: {{ apache_settings.packages|yaml }}
  file.managed:
    - name: {{ apache_settings.confdir }}_000_general.conf
    - source: salt://apache/files/general.conf.jinja
    - template: jinja
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - mode: 400                 # in case configs include sensitive data
    - require:
        - pkg: apache
  service.running:
    - name: {{ apache_settings.service }}
    - enable: True
    - require:
        - file: apache_dbdir
        - file: apache_certdir
        - file: apache_keydir
    - watch:
        - pkg: apache
        - file: apache
        - file: apache_envvars_file

apache_dbdir:
  file.directory:
    - name: {{ apache_settings.dbdir }}
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - dir_mode: 710
    - require:
        - pkg: apache

apache_certdir:
  file.directory:
    - name: {{ apache_settings.certdir }}
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - dir_mode: 755
    - require:
        - pkg: apache

apache_keydir:
  file.directory:
    - name: {{ apache_settings.keydir }}
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - dir_mode: 750
    - require:
        - pkg: apache

{% for module in apache_settings.modules if apache_settings.modules[module] is mapping %}
apache_{{ module }}_module:
  file.managed:
    - name: {{ apache_settings.confdir }}_{{ "%03d"|format(loop.index) }}_mod_{{ module }}.conf
    - source: salt://apache/files/mod_template.conf.jinja
    - template: jinja
    - context:
        module: {{ module }}
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - mode: 400                 # in case configs include sensitive data
    - require:
        - pkg: apache
    - watch_in:
        - service: apache
{% endfor %}

apache_envvars_file:
  file.managed:
    - name: {{ apache_settings.envvars_file }}
    - source: salt://apache/files/envvars.env.jinja
    - template: jinja
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - mode: 400                 # in case configs include sensitive data
    - require:
        - pkg: apache

{% for keypair in apache_settings.keypairs %}
{% if apache_settings.keypairs[keypair].certificate is defined %}
apache_{{ keypair }}_certificate:
  file.managed:
    - name: {{ apache_settings.certdir }}{{ keypair }}.cert
    - source: salt://apache/files/keypair_template.cert.jinja
    - template: jinja
    - context:
        keypair: {{ keypair }}
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - mode: 444
    - require:
        - pkg: apache
        - file: apache_certdir
    - watch_in:
        - service: apache
{% endif %}
{% if apache_settings.keypairs[keypair].key is defined %}
apache_{{ keypair }}_key:
  file.managed:
    - name: {{ apache_settings.keydir }}{{ keypair }}.key
    - source: salt://apache/files/keypair_template.key.jinja
    - template: jinja
    - context:
        keypair: {{ keypair }}
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - mode: 400
    - require:
        - pkg: apache
        - file: apache_keydir
    - watch_in:
        - service: apache
{% endif %}
{% endfor %}

{% for site in apache_settings.sites %}
apache_{{ site }}_site:
  file.managed:
    - name: {{ apache_settings.confdir }}{{ site }}.conf
    - source: salt://apache/files/site_template.conf.jinja
    - template: jinja
    - context:
        site: {{ site }}
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - mode: 400                 # in case configs include sensitive data
    - require:
        - pkg: apache
    - watch_in:
        - service: apache
{% endfor %}
