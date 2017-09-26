{%- if salt.cmd.which('dbus-uuidgen') %}

dbus_uuidgen_ensure:
  cmd.run:
    - name: dbus-uuidgen --ensure
    - creates: /var/lib/dbus/machine-id

{%- endif %}
