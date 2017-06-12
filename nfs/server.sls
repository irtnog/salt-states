## quick and dirty FreeBSD NFS server config

nfs_server:
  file.managed:
    - name: /etc/exports
    - contents_pillar: nfs_server:exports

  service.running:
    - names:
        - nfsd
        - mountd
    - enable: True
    - watch:
        - file: nfs_server
