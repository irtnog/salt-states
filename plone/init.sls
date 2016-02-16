plone:
  pkg.installed:
    - pkgs: plone
  file.directory:
    - name: /opt/plone
    - user: www
    - group: www
    - dir_mode: 755
  cmd.run:
    - name: mkzopeinstance -d /opt/plone -u admin:admin
    - user: www
    - creates: /opt/plone/var
  service.running:
    - name: zope213
    - enable: True

/etc/rc.conf:
  file.append:
    - content: |
        zope213_instances="/opt/plone"
    - require:
        - cmd: plone
    - require_in:
        - service: plone
