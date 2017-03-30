{% set reminst = 'C:\RemoteInstall' %}
wdsserver:
  # TODO: install WDS

  file.recurse:
    - name: {{ reminst|yaml_encode }}
    - source: salt://wdsserver/files
    - template: jinja
    - include_empty: yes
    - exclude_pat: E@\.gitignore

## Fixes `PXE-E32: TFTP open timeout` errors caused by WDSServer
## allocating high UDP ports without checking whether another process
## is already using them, e.g., DNSServer.
wds_tftp_open_timeout_fix:
  reg.present:
    - name: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\WDSServer\Parameters
    - vname: UdpPortPolicy
    - vtype: REG_DWORD
    - vdata: 0

## Download and install WDSLINUX.
{% set wdslinux_version = 'syslinux-6.04-pre1' %}
{% set wdslinux_download = 'https://www.kernel.org/pub/linux/utils/boot/syslinux/Testing/6.04/syslinux-6.04-pre1.zip' %}
{% set wdslinux_hash = 'sha512=5b868f5ec1fecce1209c6a69196ee969997d44e95fd8741c1e7c72df3be1f4727c9f85ad1dceb2d00a9f69729a6fcd3e96cb1f5fabe9c44ecca61524a2aa2066' %}
{% set wdslinux_prefix = salt.environ.get('ProgramFiles') + '\\' + wdslinux_version %}
wdslinux:
  file.directory:
    - name: {{ wdslinux_prefix|yaml_encode }}

  archive.extracted:
    - name: {{ wdslinux_prefix|yaml_encode }}
    - source: {{ wdslinux_download|yaml_encode }}
    - source_hash: {{ wdslinux_hash|yaml_encode }}
    - enforce_toplevel: False
    - overwrite: True
    - keep: True
    - require:
        - file: wdslinux

{%- for arch in ['x86', 'x64'] %}
{%-   for src, dst in {
        'bios\core\pxelinux.0':
          'pxelinux.com',
        'bios\com32\menu\menu.c32':
          'menu.c32',
        'bios\com32\menu\\vesamenu.c32':
          'vesamenu.c32',
        'bios\com32\chain\chain.c32':
          'chain.c32',
        'bios\com32\elflink\ldlinux\ldlinux.c32':
          'ldlinux.c32',
        'bios\com32\lib\libcom32.c32':
          'libcom32.c32',
        'bios\com32\cmenu\libmenu\libmenu.c32':
          'libmenu.c32',
      }|dictsort %}

wdslinux_{{ arch }}_{{ dst }}:
  file.copy:
    - name: {{ '%s\Boot\%s\%s'|format(reminst, arch, dst)|yaml_encode }}
    - source: {{ '%s\%s'|format(wdslinux_prefix, src)|yaml_encode }}
    - force: True
    - onchanges:
        - archive: wdslinux
    - onchanges_in:
        - cmd: wdslinux_{{ arch }}_set_boot_program

{%-   endfor %}

wdslinux_{{ arch }}_set_boot_program:
  cmd.run:
    - names:
        - {{ 'wdsutil /set-server /bootprogram:boot\%s\pxelinux.com /architecture:%s'|format(arch, arch)|yaml_encode }}
        - {{ 'wdsutil /set-server /N12bootprogram:boot\%s\pxelinux.com /architecture:%s'|format(arch, arch)|yaml_encode }}

{%- endfor %}
