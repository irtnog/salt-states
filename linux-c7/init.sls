linux-c7:
  pkg.installed:
    []

/compat/linux/proc:
  mount.mounted:
    - device: linprocfs
    - fstype: linprocfs
    - opts: rw
    - require:
        - pkg: linux-c7

/compat/linux/sys:
  mount.mounted:
    - device: linsysfs
    - fstype: linsysfs
    - opts: rw
    - require:
        - pkg: linux-c7

/compat/linux/dev/shm:
  mount.mounted:
    - device: tmpfs
    - fstype: tmpfs
    - opts: rw,mode=1777
    - require:
        - pkg: linux-c7
