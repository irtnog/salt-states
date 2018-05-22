virtualbox:
  pkg.installed:
    []

  file.directory:
    - name: 'C:\\Program Files\\Oracle\\VirtualBox\\ExtensionPacks\\Oracle_VM_VirtualBox_Extension_Pack'
    - require:
        - pkg: virtualbox

  archive.extracted:
    - name: 'C:\\Program Files\\Oracle\\VirtualBox\\ExtensionPacks\\Oracle_VM_VirtualBox_Extension_Pack'
    - source: https://download.virtualbox.org/virtualbox/5.2.12/Oracle_VM_VirtualBox_Extension_Pack-5.2.12.vbox-extpack
    - source_hash: sha256=4c36d129f17dcab2bb37292022f1b1adfefa5f32a3161b0d5d40784bc8acf4d0
    - archive_format: tar
    - enforce_toplevel: False
    - overwrite: True
    - clean: True
    - require:
        - file: virtualbox
