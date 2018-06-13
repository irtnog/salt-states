## Syscons is only available on FreeBSD.  All of the system console
## options can be overridden in Pillar.  Moused is controlled
## separately.

{% set syscons = salt['pillar.get']('syscons', {
    'keybell': 'off',
    'saver': 'green',
    'font8x16': 'iso-8x16',
    'font8x14': 'iso-8x14',
    'font8x8': 'iso-8x8',
}) %}
{% for setting in ['keyboard', 'keymap', 'keybell', 'keychange',
                   'cursor', 'scrnmap', 'blanktime', 'saver',
                   'font8x16', 'font8x14', 'font8x8',
                   'allscreens_flags', 'allscreens_kbdflags' ] %}
  {% if setting in syscons %}
    {% set value = syscons[setting] %}
syscons_{{ setting }}:
  sysrc.managed:
    - name: {{ setting|yaml_encode }}
    - value: {{ value|yaml_encode }}
    - onchanges_in:
        - module: syscons-restart
  {% endif %}
{% endfor %}

## Inert by default, this only restarts the syscons service if
## triggered by changes made above.
syscons-restart:
  module.wait:
    - name: service.restart
    - m_name: syscons
