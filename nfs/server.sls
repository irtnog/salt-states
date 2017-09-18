## quick and dirty FreeBSD NFS server config

nfs_server:
  service.running:
    - names:
        - nfsd
        - mountd
    - enable: True
