vmware_guest_redhat_textmode_console:
  file.replace:
    - name: /etc/sysconfig/grub
    - pattern: '^(GRUB_CMDLINE_LINUX="((?! nomodeset vga=normal).)*)"$'
    - repl: '\1 nomodeset vga=normal"'
    - backup: False

  cmd.run:
    - name:
{%- if salt['file.file_exists']('/boot/grub2/grub.cfg') %}
        grub2-mkconfig -o /boot/grub2/grub.cfg
{%- elif salt['file.file_exists']('/boot/efi/EFI/redhat/grub.conf') %}
        grub2-mkconfig -o /boot/efi/EFI/redhat/grub.conf
{%- else %}
        'true'
{%- endif %}
    - onchanges:
        - file: vmware_guest_redhat_textmode_console
