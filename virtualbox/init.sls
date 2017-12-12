virtualbox:
  pkg.installed:
    []

  file.managed:
    - name: 'C:\\Program Files\\Oracle\\VirtualBox\\Oracle_VM_VirtualBox_Extension_Pack.vbox-extpack'
    - source: http://download.virtualbox.org/virtualbox/5.2.2/Oracle_VM_VirtualBox_Extension_Pack-5.2.2-119230.vbox-extpack
    - source_hash: sha256=9328548ca8cbc526232c0631cb5a17618c771b07665b362c1e3d89a2425bf799
    - require:
        - pkg: virtualbox

  cmd.run:
    - name: vboxmanage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack.vbox-extpack
    - cwd: 'C:\\Program Files\\Oracle\\VirtualBox\\'
    - onchanges:
        - file: virtualbox
