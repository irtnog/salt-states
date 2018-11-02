{% if salt['grains.get']('os_family') == 'RedHat' %}

yum:
  pkg.installed:
    - pkgs:
        - deltarpm
        - yum-cron
        - rpm-build
        - rpm-sign
        - createrepo

{% endif %}
