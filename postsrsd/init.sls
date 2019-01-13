{%- from 'postsrsd/map.jinja' import postsrsd %}

postsrsd:
  pkg.installed:
    - pkgs: {{ postsrsd.packages|yaml }}

{%- if postsrsd.config_file %}

  file.managed:
    - name: {{ postsrsd.config_file|yaml_encode }}
    - source: salt://postsrsd/files/{{ grains['os_family']|lower }}.conf
    - template: jinja
    - require:
        - pkg: postsrsd
    - watch_in:
        - pkg: postsrsd

{%- endif %}

  service.running:
    - names: {{ postsrsd.services|yaml }}
    - enable: True
    - watch:
        - pkg: postsrsd

{%- if grains['os_family'] == 'FreeBSD' %}

postsrsd_srs_secret:
  file.managed:
    - name: /usr/local/etc/postsrsd.secret
    - contents: {{ postsrsd.srs_secret|yaml_encode }}
    - user: root
    - group: mailnull
    - mode: 640

{%- endif %}
