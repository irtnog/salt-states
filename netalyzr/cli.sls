{% set prefix =
  'C:\\Program Files\\NetalyzrCLI\\'
    if grains['os_family'] == 'Windows' else
  '/usr/local/bin/' %}

netalyzr_cli:
  file.managed:
    - name: {{ '%sNetalyzrCLI.jar'|format(prefix)|yaml_encode }}
    - source: http://netalyzr.icsi.berkeley.edu/NetalyzrCLI.jar
    - source_hash: sha512=be798be7929a524d24d4c40da93d454ff3d5ed101a3fbc30f59b4b3ea09081ab7e2163dde7c86d17b72ad668a5f623012f2f112b778ed88d939eb8ba48a07c89
    {%- if grains['os_family'] != 'Windows' %}
    - mode: 755
    {%- endif %}
    - makedirs: True
