{% if grains['os_family'] == 'FreeBSD' %}

bgfsck:
  service.disabled

rc_conf_bgfsck_settings:
  file.accumulated:
    - name: rc_conf_accumulator
    - filename: /etc/rc.conf
    - text: 'fsck_y_enable="YES"'
    - require_in:
      - file: rc_conf

{% endif %}
