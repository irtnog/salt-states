{% from "apache/map.jinja" import apache with context %}

include:
  - apache

## This assumes the Apache module (included in the shibboleth package)
## is already installed.

mod_shib:
  file.managed:
    - name: {{
        '%s/%s'|format(
          apache.modulesdir if 'modulesdir' in apache else apache.confdir,
          '070_mod_shib.conf' if grains['os_family'] == 'FreeBSD' else 'shib.conf'
        )|yaml_encode  
      }}
    - source: salt://apache/files/{{ grains['os_family'] }}/mod_shib.conf.jinja
    - mode: 644
    - template: jinja
    - require:
        - pkg: apache
    - watch_in:
        - module: apache-restart
