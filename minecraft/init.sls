minecraft:
  pkg.installed:
    []

{%- if grains['os_family'] == 'Windows' %}

minecraft_shortcut:
  file.managed:
    - name:
        {{ salt['environ.get']('ProgramData') }}\Microsoft\Windows\Start Menu\Programs\Minecraft\Minecraft (roaming profile).lnk
    - source:
        salt://minecraft/files/Minecraft (roaming profile).lnk

{%- endif %}
