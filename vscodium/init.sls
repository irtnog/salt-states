vscodium:
  pkgrepo.managed:
    - name: deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main
    - key_url: https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg

  pkg.installed:
    - require:
        - pkgrepo: vscodium
