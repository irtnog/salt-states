{%- set oscodename = salt['grains.get']('oscodename') %}

apt_sources_list:
  file.managed:
    - name: /etc/apt/sources.list
    - contents: |
        deb http://us.archive.ubuntu.com/ubuntu/ {{ oscodename }} main universe restricted multiverse
        deb-src http://us.archive.ubuntu.com/ubuntu/ {{ oscodename }} main universe restricted multiverse

        deb http://us.archive.ubuntu.com/ubuntu/ {{ oscodename }}-security main universe restricted multiverse
        deb-src http://us.archive.ubuntu.com/ubuntu/ {{ oscodename }}-security main universe restricted multiverse

        deb http://us.archive.ubuntu.com/ubuntu/ {{ oscodename }}-updates main universe restricted multiverse
        deb-src http://us.archive.ubuntu.com/ubuntu/ {{ oscodename }}-updates main universe restricted multiverse
        deb http://us.archive.ubuntu.com/ubuntu/ {{ oscodename }}-backports universe main restricted multiverse
        deb http://us.archive.ubuntu.com/ubuntu/ {{ oscodename }}-proposed universe multiverse main restricted
    - watch_in:
        - module: apt_update

{%- if salt['grains.get']('cpuarch') == 'x86_64' %}

dpkg_arch:
  file.managed:
    - name: /var/lib/dpkg/arch
    - contents: |
        amd64
        i386
    - watch_in:
        - module: apt_update

{%- endif %}

apt_update:
  module.wait:
    - name: pkg.refresh_db
