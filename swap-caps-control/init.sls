#### SWAP-CAPS-CTRL/INIT.SLS --- Swap the Caps Lock and Left Control keys

#### This moves the Control key to the home row like God intended.
#### How this gets accomplished is different for each operating
#### system.  On Linux, we change the keyboard(5) configuration via
#### systemd following the X Keyboard Extension (XKB) protocol
#### specification.  On Windows, we hack the scancode map, which can
#### break laptop hotkeys (e.g., the SAK on the Scribbler, the Action
#### Center key on the G50).

{%- if grains['virtual'] == 'physical' %}
{%-   if grains['os_family'] == 'Debian' %}

## FIXME: restart required?
swap_caps_control:
  file.managed:
    - name: /etc/default/keyboard
    - contents: |
        XKBLAYOUT="us"
        BACKSPACE="guess"
        XKBOPTIONS="ctrl:swapcaps"
        XKBMODEL="pc105"
        XKBVARIANT=""

{%-   elif grains['os_family'] == 'RedHat' %}

## FIXME: not stateful, doesn't preserve existing locale/keyboard
swap_caps_control:
  cmd.run:
    - name: localectl set-x11-keymap us pc105 "" ctrl:swapcaps

{%-   elif grains['os_family'] == 'Windows' %}

swap_caps_control:
  reg.present:
    - name: HKLM\\SYSTEM\\CurrentControlSet\\Control\\Keyboard Layout
    - vname: Scancode Map
    - vtype: REG_BINARY
    ## 0x00 0x00 0x00 0x00 - version (0)
    ## 0x00 0x00 0x00 0x00 - reserved (0)
    ## 0x03 0x00 0x00 0x00 - number of entries (3)
    ## 0x3A 0x00 0x1D 0x00 - entry 1: map Caps Lock to Left Control
    ## 0x1D 0x00 0x3A 0x00 - entry 2: map Left Control to Caps Lock
    ## 0x00 0x00 0x00 0x00 - entry 3: null terminator
    - vdata: !binary |
        AAAAAAAAAAADAAAAHQA6ADoAHQAAAAAA

  system.reboot:
    - order: last
    - watch:
        - reg: swap_caps_control

{%-   endif %}
{%- endif %}

#### SWAP-CAPS-CTRL/INIT.SLS ends here.
