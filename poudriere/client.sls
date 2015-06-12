{% if salt['grains.get']('os_family') == 'FreeBSD' %}

install_irtnog_pubkey:
  file:
    - managed
    - name: /usr/local/etc/pkg/repos/irtnog.pub
    - user: root
    - group: 0
    - mode: 444
    - makedirs: True
    - dir_mode: 755
    - source: salt://poudriere/files/irtnog.pub

install_irtnog_repo:
  file:
    - managed
    - name: /usr/local/etc/pkg/repos/irtnog.conf
    - user: root
    - group: 0
    - mode: 444
    - makedirs: True
    - dir_mode: 755
    {% if salt['pillar.get']('repos:freebsd:irtnog_conf', False) %}
    - contents_pillar: repos:freebsd:irtnog_conf
    {% else %}
    - source: salt://poudriere/files/irtnog.conf
    {% endif %}

install_make_conf:
  cmd:
    - run
    - name: touch /etc/make.conf
    - onlyif: test ! -f /etc/make.conf
  file:
    - append
    - name: /etc/make.conf
    - source: salt://poudriere/files/make.conf.jinja
    - template: jinja

{% if salt['pillar.get']('repos:freebsd:enabled', False) %}
enable_freebsd_repo::
  file:
    - absent
    - name: /usr/local/etc/pkg/repos/FreeBSD.conf
    - require:
      - file: install_irtnog_repo
{% else %}
disable_freebsd_repo:
  file:
    - managed
    - name: /usr/local/etc/pkg/repos/FreeBSD.conf
    - user: root
    - group: 0
    - mode: 444
    - makedirs: True
    - dir_mode: 755
    - source: salt://poudriere/files/FreeBSD.conf
    - require:
      - file: install_irtnog_repo
{% endif %}

{% endif %}
