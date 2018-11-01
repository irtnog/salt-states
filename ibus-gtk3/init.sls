{%- if salt['grains.get']('osfinger') == 'Ubuntu-18.04' %}

## downgrade ibus-gtk3 to fix issues with popups affecting 1Password X
## https://discussions.agilebits.com/discussion/90011/lock-screen-issue-1password-x-for-firefox-on-ubuntu-18-04/p1
## https://packages.ubuntu.com/artful/amd64/ibus-gtk3/download

ibus-gtk3:
  pkg.installed:
    - sources:
        - ibus-gtk3:
            http://mirrors.kernel.org/ubuntu/pool/main/i/ibus/ibus-gtk3_1.5.14-2ubuntu1_amd64.deb
    - hold: True
    - update_holds: True

{%- endif %}
