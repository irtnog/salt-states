{% from "jetty/map.jinja" import jetty_settings with context %}

jetty:
  pkg.installed:
    - pkgs: {{ jetty_settings.packages|yaml }}
  group.present:
    - name: {{ jetty_settings.group }}
  user.present:
    - name: {{ jetty_settings.user }}
    - home: {{ jetty_settings.prefix }}
    - password: '*'
    - require:
        - pkg: jetty
  service.running:
    - names: {{ jetty_settings.services|yaml }}
    - enable: True
    - watch:
        - pkg: jetty

## TODO: configuration via Pillar à la the apache SLS

{% if jetty_settings.install_from_source %}

jetty_dist:
  archive.extracted:
    - name: {{ jetty_settings.prefix }}/..
    - source: {{ jetty_settings.dist.url }}
    - source_hash: {{ jetty_settings.dist.hash }}
    - archive_format: tar
    - if_missing: {{ jetty_settings.prefix }}/../{{ jetty_settings.dist.folder }}
    - watch_in:
        - service: jetty
  file.directory:
    - name: {{ jetty_settings.prefix }}/../{{ jetty_settings.dist.folder }}
    - user: {{ jetty_settings.user }}
    - group: {{ jetty_settings.group }}
    - recurse:
        - user
        - group
    - require:
        - user: jetty
    - watch:
        - archive: jetty_dist
    - watch_in:
        - service: jetty
  mount.mounted:
    - name: {{ jetty_settings.prefix }}
    {% if grains['kernel'] == 'Linux' %}
    - device: overlay
    - fstype: overlay
    - opts:
        - lowerdir={{ jetty_settings.prefix }}/../{{ jetty_settings.dist.folder }}
        - upperdir={{ jetty_settings.prefix }}
        - workdir={{ jetty_settings.prefix }}/../.jetty_workdir
    {% else %}
    - device: {{ jetty_settings.prefix }}/../{{ jetty_settings.dist.folder }}
    - fstype: union
    {% endif %}
    - require:
        - file: jetty_dist
        {% if grains['kernel'] == 'Linux' %}
        - file: jetty_workdir
        {% endif %}
    - watch_in:
        - service: jetty

{% if grains['kernel'] == 'Linux' %}
jetty_workdir:
  file.directory:
    - name: {{ jetty_settings.prefix }}/../.jetty_workdir
{% endif %}

{% if 'systemd' in grains %}
jetty_unit_file:
  file.managed:
    - name: /usr/lib/systemd/system/jetty.service
    - source: salt://jetty/files/jetty.service.jinja
    - template: jinja
    - require_in:
        - service: jetty
{% else %}
# TODO: SMF, SysV, and rc-style init scripts
{% endif %}

{% endif %}
