glass_tty_vt220:
  pkg.installed:
    - pkgs:
        - xorg-fonts-truetype
        - fontconfig
  file.managed:
    - name: /usr/local/share/fonts/TTF/Glass_TTY_VT220.ttf
    - source: http://sensi.org/%7Esvo/glasstty/Glass_TTY_VT220.ttf
    - source_hash: sha512=0b3b598bbdcc8f1177b48a7cedd2ad035a8a95d17d162d868e7c988a9d918f2756a8fe674bef3f30357225a87ea4e3adde01889502540d6920210161edc37023
    - user: root
    - group: 0
    - mode: 555
    - require:
        - pkg: glass_tty_vt220
  cmd.wait:
    - name: fc-cache -s -v
    - watch:
        - pkg: glass_tty_vt220
        - file: glass_tty_vt220
