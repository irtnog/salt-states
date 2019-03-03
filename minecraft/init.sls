minecraft:
  pkg.installed:
    []

{%- if grains['os_family'] == 'Windows' %}

minecraft_shortcut:
  file.managed:
    - name:
        {{ salt['environ.get']('ProgramData') }}\Microsoft\Windows\Start Menu\Programs\Minecraft Launcher\Minecraft Launcher.lnk
    - source:
        salt://minecraft/files/Minecraft Launcher.lnk

{%- endif %}
