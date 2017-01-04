{% from "moused/map.jinja" import moused_settings with context %}

moused:
  service.running:
    - enable: True

{% if moused_settings.nondefault_enable is not none %}
moused_nondefault_enable:
  sysrc.managed:
    - value: {{ 'YES' if moused_settings.nondefault_enable else 'NO' }}
    - watch_in:
        - service: moused
{% endif %}

{% if moused_settings.type is not none %}
moused_type:
  sysrc.managed:
    - value: {{ moused_settings.type|yaml_encode }}
    - watch_in:
        - service: moused
{% endif %}

{% if moused_settings.port is not none %}
moused_port:
  sysrc.managed:
    - value: {{ moused_settings.moused_port|yaml_encode }}
    - watch_in:
        - service: moused
{% endif %}

{% if moused_settings.flags is not none %}
moused_flags:
  sysrc.managed:
    - value: {{ moused_settings.moused_flags|yaml_encode }}
    - watch_in:
        - service: moused
{% endif %}

{% if moused_settings.mousechar_start is not none %}
mousechar_start:
  sysrc.managed:
    - value: {{ moused_settings.mousechar_start|yaml_encode }}
    - watch_in:
        - service: moused
{% endif %}
