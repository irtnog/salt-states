## Poudriere only works on FreeBSD.  It also requires the apache state.
{% if grains['os_family'] == 'FreeBSD' %}

poudriere:
  pkg.installed:
    - pkgs:
        - poudriere-devel
        - ccache
        - qemu-user-static

qemu_user_static:
  service.running:
    - enable: True
    - watch:
        - pkg: poudriere

poudriere_pkglist:
  file.managed:
    - name: /usr/local/etc/pkglist
    - source: salt://poudriere/files/pkglist.jinja
    - template: jinja
    - user: root
    - group: 0
    - mode: 444

poudriere_repo_key:
  file.managed:
    - name: {{ salt['pillar.get']('poudriere:pkg_repo_signing_key', '/etc/ssl/keys/repo.key') }}
    - user: root
    - group: 0
    - mode: 400
    - makedirs: True
    - dir_mode: 700
    - contents_pillar: poudriere:repo:secret

poudriere_svn_cert:
  file.managed:
    - name: /root/.subversion/auth/svn.ssl.server/87ff8e8fd0384311d1630a5693b2abb5
    - source: salt://poudriere/files/87ff8e8fd0384311d1630a5693b2abb5
    - user: root
    - group: 0
    - mode: 644
    - makedirs: True
    - dir_mode: 755

poudriere_make_conf:
  file.managed:
    - name: /usr/local/etc/poudriere.d/make.conf
    - source: salt://poudriere/files/make.conf.jinja
    - template: jinja
    - user: root
    - group: 0
    - mode: 644
    - require:
        - pkg: poudriere

poudriere_conf:
  file.managed:
    - name: /usr/local/etc/poudriere.conf
    - source: salt://poudriere/files/poudriere.conf.jinja
    - template: jinja
    - user: root
    - group: 0
    - mode: 644
    - require:
        - pkg: poudriere
        - file: poudriere_repo_key
        - file: poudriere_svn_cert
        - file: poudriere_make_conf

# poudriere_ports_create:
#   cmd:
#     - run
#     - name: poudriere ports -c -m svn+https
#     - onlyif: test ! -d /var/poudriere/ports/default/
#     - require:
#         - file: poudriere_conf

# poudriere_ports_update:
#   cron:
#     - present
#     - name: poudriere ports -u
#     - identifier: poudriere_ports_update
#     - user: root
#     - minute: random
#     - hour: random
#     - dayweek: 3
#     - require:
#         - cmd: poudriere_ports_create

# poudriere_jail_freebsd_10_x86_32_create:
#   cmd:
#     - run
#     - name: poudriere jail -c -j freebsd:10:x86:32 -v 10.0-RELEASE -a i386
#     - onlyif: test ! -d /var/poudriere/jails/freebsd:10:x86:32
#     - require:
#         - file: poudriere_conf

# poudriere_jail_freebsd_10_x86_32_update:
#   cron:
#     - present
#     - name: poudriere jail -u -j freebsd:10:x86:32
#     - identifier: poudriere_jail_freebsd_10_x86_32_update
#     - user: root
#     - minute: random
#     - hour: random
#     - dayweek: 3
#     - require:
#         - cmd: poudriere_jail_freebsd_10_x86_32_create

# poudriere_jail_freebsd_10_x86_64_create:
#   cmd:
#     - run
#     - name: poudriere jail -c -j freebsd:10:x86:64 -v 10.0-RELEASE -a amd64
#     - onlyif: test ! -d /var/poudriere/jails/freebsd:10:x86:64
#     - require:
#         - file: poudriere_conf

# poudriere_jail_freebsd_10_x86_64_update:
#   cron:
#     - present
#     - name: poudriere jail -u -j freebsd:10:x86:64
#     - identifier: poudriere_jail_freebsd_10_x86_64_update
#     - user: root
#     - minute: random
#     - hour: random
#     - dayweek: 3
#     - require:
#         - cmd: poudriere_jail_freebsd_10_x86_64_create

# poudriere_bulk:
#   cron:
#     - present
#     - name: poudriere bulk -f /usr/local/etc/pkglist
#     - identifier: poudriere_bulk
#     - user: root
#     - minute: random
#     - hour: random
#     - dayweek: 6
#     - require:
#         - cmd: poudriere_ports_create
#         - cmd: poudriere_jail_freebsd_10_x86_32_create
#         - cmd: poudriere_jail_freebsd_10_x86_64_create

# poudriere_bulk_freebsd_10_x86_32:
#   cron:
#     - present
#     - name: poudriere bulk -f /usr/local/etc/pkglist -j freebsd:10:x86:32
#     - identifier: poudriere_bulk_freebsd_10_x86_32
#     - user: root
#     - minute: random
#     - hour: random
#     - dayweek: 6
#     - require:
#         - cmd: poudriere_ports_create
#         - cmd: poudriere_jail_freebsd_10_x86_32_create
#         - cmd: poudriere_jail_freebsd_10_x86_64_create

# poudriere_bulk_freebsd_10_x86_64:
#   cron:
#     - present
#     - name: poudriere bulk -f /usr/local/etc/pkglist -j freebsd:10:x86:64
#     - identifier: poudriere_bulk_freebsd_10_x86_64
#     - user: root
#     - minute: random
#     - hour: random
#     - dayweek: 6
#     - require:
#         - cmd: poudriere_ports_create
#         - cmd: poudriere_jail_freebsd_10_x86_32_create
#         - cmd: poudriere_jail_freebsd_10_x86_64_create

{% endif %}
