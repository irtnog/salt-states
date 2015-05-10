## Syscons is only available on FreeBSD.  All of the system console
## options can be overridden in Pillar.  Moused is controlled
## separately.

{% if grains['os_family'] == 'FreeBSD' %}
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
rc_conf_syscons_{{ setting }}:
  file:
    - accumulated
    - name: rc_conf_accumulator
    - filename: /etc/rc.conf
    - text: '{{ setting }}="{{ value }}"'
    - require_in:
      - file: rc_conf
  {% endif %}
{% endfor %}
{% endif %}
