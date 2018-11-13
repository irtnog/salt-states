yum:
  pkg.installed:
    - pkgs:
        - deltarpm
        - yum-cron
        - rpm-build
        - rpm-sign
        - createrepo

  pkgrepo.managed:
    - name: irtnog
    - humanname: IRTNOG Package Repository for RHEL/CentOS $releasever
    - baseurl: https://yum.irtnog.org/$releasever/$basearch/latest
    - gpgkey: https://yum.irtnog.org/RPM-GPG-KEY-xenophon@irtnog.org
    - gpgcheck: 1
