## Add clamav to the vscan group, so that the antivirus scan engine
## can access the mail spool directories.  (The amavisd packages will
## create the group.)  Note that this might be FreeBSD-specific.

vscan:
  group.present:
    - addusers:
        - clamav
    - require:
        - pkg: amavisd
        - pkg: clamav
    - watch_in:
        - service: clamav
