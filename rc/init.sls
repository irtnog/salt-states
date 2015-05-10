{% if grains['os_family'] == 'FreeBSD' %}

rc_conf:
  file:
    - blockreplace
    - name: /etc/rc.conf
    - append_if_not_found: True
    - backup: False

rc_conf_general_settings:
  file:
    - accumulated
    - name: rc_conf_accumulator
    - filename: /etc/rc.conf
    - text: 'clear_tmp_enable="YES"'
    - require_in:
      - file: rc_conf

{% endif %}
