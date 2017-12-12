virtualbox:
  pkg.installed:
    []

  file.directory:
    - name: 'C:\\Program Files\\Oracle\\VirtualBox\\ExtensionPacks\\Oracle_VM_VirtualBox_Extension_Pack'
    - require:
        - pkg: virtualbox

  archive.extracted:
    - name: 'C:\\Program Files\\Oracle\\VirtualBox\\ExtensionPacks\\Oracle_VM_VirtualBox_Extension_Pack'
    - source: http://download.virtualbox.org/virtualbox/5.2.2/Oracle_VM_VirtualBox_Extension_Pack-5.2.2.vbox-extpack
    - source_hash: sha256=9328548ca8cbc526232c0631cb5a17618c771b07665b362c1e3d89a2425bf799
    - archive_format: tar
    - enforce_toplevel: False
    - overwrite: True
    - clean: True
    - require:
        - file: virtualbox
