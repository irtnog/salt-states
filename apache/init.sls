{% from "apache/map.jinja" import apache_settings with context %}

apache:
  pkg.installed:
    - pkgs: {{ apache_settings.packages|yaml }}
  service.running:
    - name: {{ apache_settings.service }}
    - enable: True
    - require:
      - file: apache_dbdir
      - file: apache_certs
      - file: apache_keys
    - watch:
      - pkg: apache

apache_dbdir:
  file.directory:
    - name: {{ apache_settings.dbdir }}
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - dir_mode: 710
    - require:
      - pkg: apache

apache_certs:
  file.directory:
    - name: {{ apache_settings.certs }}
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - dir_mode: 755
    - require:
      - pkg: apache

apache_keys:
  file.directory:
    - name: {{ apache_settings.keys }}
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - dir_mode: 750
    - require:
      - pkg: apache

{% for module in apache_settings.modules %}
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

{% for keypair in apache_settings.keypairs %}
apache_{{ keypair }}_certificate:
  file.managed:
    - name: {{ apache_settings.certs }}{{ keypair }}.crt
    - source: salt://apache/files/keypair_template.crt.jinja
    - template: jinja
    - context:
        keypair: {{ keypair }}
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - mode: 644
    - require:
      - pkg: apache
      - file: apache_certs
    - watch_in:
      - service: apache

apache_{{ keypair }}_key:
  file.managed:
    - name: {{ apache_settings.keys }}{{ keypair }}.key
    - source: salt://apache/files/keypair_template.key.jinja
    - template: jinja
    - context:
        keypair: {{ keypair }}
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - mode: 600
    - require:
      - pkg: apache
      - file: apache_certs
    - watch_in:
      - service: apache
{% endfor %}

{% for site in apache_settings.sites %}
apache_{{ site }}_site:
  file.managed:
    - name: {{ apache_settings.confdir }}_{{ "%03d"|format(loop.index) }}_site_{{ site }}.conf
    - source: salt://apache/files/site_template.conf.jinja
    - template: jinja
    - context:
        site: {{ site }}
    - user: {{ apache_settings.user }}
    - group: {{ apache_settings.group }}
    - mode: 400
    - require:
      - pkg: apache
    - watch_in:
      - service: apache
{% endfor %}
