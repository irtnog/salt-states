wix-toolset:
  win_dism.feature_installed:
    - name: NetFx3

  pkg.installed:
    - require:
        - win_dism: wix-toolset
