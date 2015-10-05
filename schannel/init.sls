{% set osrelease = salt['grains.get']('osversion').split('.')
{% set osmajorrelease = osrelease[0]|int %}
{% set osminorrelease = osrelease[1]|int %}
{% set schannel = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL' %}

## Windows Server 2008 R2 supports TLS 1.2 but does not enable it by
## default.  After changing the registry, the server must be rebooted.
{{ schannel }}\Protocols\TLS 1.2\Server\DisabledByDefault:
  reg.present:
    - vtype: REG_DWORD
    - value: 0

## Disable anything older than TLS 1.2 server-side or TLS 1.0
## client-side.  Do not disable server-side TLS 1.0 on Windows Server
## 2008 or older, as these operating systems lack support for anything
## better.  Note that this ciphersuite configuration may break
## client-side access to older web applications or services.
{% if osmajorrelease < 6 or (osmajorrelease == 6 and osminorrelease < 1) %}
  {% set disable_protocols_server = [ 'PCT 1.0', 'SSL 2.0', 'SSL 3.0', ] %}
{% else %}
  {% set disable_protocols_server = [ 'PCT 1.0', 'SSL 2.0', 'SSL 3.0', 'TLS 1.0', 'TLS 1.1', ] %}
{% endif %}
{% for protocol in disable_protocols_sever %}
{{ schannel }}\Protocols\{{ protocol }}\Server\Enabled:
  reg.present:
    - vtype: REG_DWORD
    - value: 0
  {% endif %}
{% for protocol in [ 'PCT 1.0', 'SSL 2.0', 'SSL 3.0', ] %}
{{ schannel }}\Protocols\{{ protocol }}\Client\DisabledByDefault:
  reg.present:
    - vtype: REG_DWORD
    - value: 1
{% endfor %}

{% if osmajorrelease < 6 or (osmajorrelease == 6 and osminorrelease < 1) %}
{{ schannel }}\Protocols\TLS 1.0\Server\Enabled:
  reg.present:
    - vtype: REG_DWORD
    - value: 0
{% endif %}

## Disable weak encryption and hash algorithms across the board.
## These changes take effect immediately.
{% for cipher in [ 'NULL', 'DES 56/56', 'RC2 40/128', 'RC2 128/128', 'RC4 40/128', 'RC4 56/128', ] %}
{{ schannel }}\Ciphers\{{ cipher }}\Enabled:
  reg.present:
    - vtype: REG_DWORD
    - value: 0
{% endfor %}
{% for hash in [ 'MD5', ] %}
{{ schannel }}\Hashes\{{ hash }}\Enabled:
  reg.present:
    - vtype: REG_DWORD
    - value: 0
{% endfor %}
