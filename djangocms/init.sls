#### DJANGOCMS/INIT.SLS --- Deploy djangoCMS into a Python 2.7 virtual environment

djangocms:
  pkg.installed:
    - pkgs: {{ salt['pillar.get']('djangocms:packages', ['apache24', 'py27-virtualenv'])|yaml }}

  file.directory:
    - name: /usr/local/www/djangocms
    - user: www
    - group: www
    - dir_mode: 751

  virtualenv.managed:
    - name: /usr/local/www/djangocms
    - user: www
    - pip_upgrade: True
    - pip_pkgs: {{ salt['pillar.get']('djangocms:pip-packages', ['djangocms-installer'])|yaml }}
    - require:
        - pkg: djangocms
        - file: djangocms

{%- for site, settings in salt['pillar.get']('djangocms:sites', {})|dictsort %}

djangocms_{{ site }}:
  cmd.run:
    ## FIXME: replace `true` with the appropriate post-upgrade command
    - name: |
        [[ ! -e {{ site }} ]] && djangocms-installer {{ site }} || true
    - runas: www
    - watch:
        - pkg: djangocms
        - virtualenv: djangocms

  file.managed:
    - name: /usr/local/www/djangocms/{{ site }}/{{ site }}/settings.py
    - source: salt://djangocms/files/settings.py
    - template: jinja
    - context:
        site: {{ site|yaml_encode }}
        settings: {{ settings|yaml }}
    - require:
        - cmd: djangocms_{{ site }}

{%- endfor %}

#### DJANGOCMS/INIT.SLS ends here.