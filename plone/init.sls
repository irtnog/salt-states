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
  sysrc.managed:
    - name: zope213_instances
    - value: "/opt/plone"
    - require:
        - cmd: plone
  service.running:
    - name: zope213
    - enable: True
    - watch:
        - pkg: plone
        - sysrc: plone
