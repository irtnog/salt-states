plone:
  pkg.installed: []
  file.directory:
    - name: /opt/plone
    - user: www
    - group: www
    - dir_mode: 755
    - require:
        - pkg: plone
  cmd.run:
    - name: mkzopeinstance -d /opt/plone -u admin:admin
    - user: www
    - creates: /opt/plone/var
    - require:
        - file: plone
  service.running:
    - name: zope213
    - enable: True
    - watch:
        - pkg: plone
        - file: rc_conf_plone

rc_conf_plone:
  file.accumulated:
    - name: rc_conf_accumulator
    - filename: /etc/rc.conf
    - text: zope213_instances="/opt/plone"
    - require:
        - cmd: plone
