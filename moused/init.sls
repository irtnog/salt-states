{% if grains['os_family'] == 'FreeBSD' %}
{% if salt['pillar.get']('moused:enable', True) %}

moused:
  service.running:
    - enable: True
    - watch:
      - file: rc_conf

{% set moused_nondefault_enable = salt['pillar.get']('moused:nondefault_enable', None) %}
{% if moused_nondefault_enable %}
rc_conf_moused_nondefault_enable:
  file.accumulated:
    - name: rc_conf_accumulator
    - filename: /etc/rc.conf
    - text: 'moused_nondefault_enable="{{ moused_nondefault_enable }}"'
    - require_in:
      - file: rc_conf
{% endif %}

{% set moused_type = salt['pillar.get']('moused:type', None) %}
{% if moused_type %}
rc_conf_moused_type:
  file.accumulated:
    - name: rc_conf_accumulator
    - filename: /etc/rc.conf
    - text: 'moused_type="{{ moused_type }}"'
    - require_in:
      - file: rc_conf
{% endif %}

{% set moused_port = salt['pillar.get']('moused:port', None) %}
{% if moused_port %}
rc_conf_moused_port:
  file.accumulated:
    - name: rc_conf_accumulator
    - filename: /etc/rc.conf
    - text: 'moused_port="{{ moused_port }}"'
    - require_in:
      - file: rc_conf
{% endif %}

{% set moused_flags = salt['pillar.get']('moused:flags', None) %}
{% if moused_flags %}
rc_conf_moused_flags:
  file.accumulated:
    - name: rc_conf_accumulator
    - filename: /etc/rc.conf
    - text: 'moused_flags="{{ moused_flags }}"'
    - require_in:
      - file: rc_conf
{% endif %}

{% set mousechar_start = salt['pillar.get']('moused:mousechar_start', None) %}
{% if mousechar_start %}
rc_conf_mousechar_start:
  file.accumulated:
    - name: rc_conf_accumulator
    - filename: /etc/rc.conf
    - text: 'mousechar_start="{{ mousechar_start }}"'
    - require_in:
      - file: rc_conf
{% endif %}

{% else %} {# if salt['pillar.get']('moused:enable', True) #}

moused:
  service.dead:
    - enable: False

{% endif %} {# if salt['pillar.get']('moused:enable', True) #}
{% endif %} {# grains['os_family'] == 'FreeBSD' #}
