## workaround for https://bugs.launchpad.net/ubuntu/+source/systemd/+bug/1745664
## see also https://github.com/systemd/systemd/issues/7074#issuecomment-338384997

nscd:
  pkg.installed:
    []
