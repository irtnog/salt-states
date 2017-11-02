{% from "apache/map.jinja" import apache with context %}

include:
  - apache

{% if grains['os_family']=="FreeBSD" %}

{{ apache.modulesdir }}/070_mod_shib.conf:
  file.managed:
    - source: salt://apache/files/{{ salt['grains.get']('os_family') }}/mod_shib.conf.jinja
    - mode: 644
    - template: jinja
    - require:
      - pkg: apache
    - watch_in:
      - module: apache-restart

{% elif grains['os_family']=='RedHat' %}

mod_shib:
  pkg.installed:
    - name: {{ apache.mod_shib }}
    - require:
        - pkg: apache
    - watch_in:
        - module: apache-restart

{{ apache.confdir }}/shib.conf:
  file.managed:
    - source: salt://apache/files/{{ salt['grains.get']('os_family') }}/mod_shib.conf.jinja
    - mode: 644
    - template: jinja
    - require:
        - pkg: apache
    - watch_in:
        - module: apache-restart

{% endif %}
