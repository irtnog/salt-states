{% if grains['os_family'] == 'Windows' %}

{% set schannel = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL' %}

### Windows Server 2008 R2 supports TLS 1.2 but does not enable it by
### default.  After changing the registry, the server must be
### rebooted.

{{ schannel }}\Protocols\TLS 1.2\Server\DisabledByDefault:
  reg:
    - present
    - vtype: REG_DWORD
    - value: 0

### Disable anything older than TLS 1.2 server-side or TLS 1.0
### client-side.  Note that this ciphersuite configuration may break
### client-side access to older web applications or services.

{{ schannel }}\Protocols\PCT 1.0\Client\DisabledByDefault:
  reg:
    - present
    - vtype: REG_DWORD
    - value: 1

{{ schannel }}\Protocols\PCT 1.0\Server\Enabled:
  reg:
    - present
    - vtype: REG_DWORD
    - value: 0

{{ schannel }}\Protocols\SSL 2.0\Client\DisabledByDefault:
  reg:
    - present
    - vtype: REG_DWORD
    - value: 1

{{ schannel }}\Protocols\SSL 2.0\Server\Enabled:
  reg:
    - present
    - vtype: REG_DWORD
    - value: 0

{{ schannel }}\Protocols\SSL 3.0\Client\DisabledByDefault:
  reg:
    - present
    - vtype: REG_DWORD
    - value: 1

{{ schannel }}\Protocols\SSL 3.0\Server\Enabled:
  reg:
    - present
    - vtype: REG_DWORD
    - value: 0

## Do not disable server-side TLS 1.0 on Windows Server 2008 or older,
## as these operating systems lack support for anything better.
{% if grains['osversion'] >= '6.1.7601' %}
{{ schannel }}\Protocols\TLS 1.0\Server\Enabled:
  reg:
    - present
    - vtype: REG_DWORD
    - value: 0
{% endif %} {# if grains['osversion'] < '6.1.7601' #}

### Disable weak encryption and hash algorithms across the board.
### These changes take effect immediately.

{{ schannel }}\Ciphers\DES 56/56\Enabled:
  reg:
    - present
    - vtype: REG_DWORD
    - value: 0

{{ schannel }}\Ciphers\NULL\Enabled:
  reg:
    - present
    - vtype: REG_DWORD
    - value: 0

{{ schannel }}\Ciphers\RC2 128/128\Enabled:
  reg:
    - present
    - vtype: REG_DWORD
    - value: 0

{{ schannel }}\Ciphers\RC2 40/128\Enabled:
  reg:
    - present
    - vtype: REG_DWORD
    - value: 0

{{ schannel }}\Ciphers\RC4 40/128\Enabled:
  reg:
    - present
    - vtype: REG_DWORD
    - value: 0

{{ schannel }}\Ciphers\RC4 56/128\Enabled:
  reg:
    - present
    - vtype: REG_DWORD
    - value: 0

{{ schannel }}\Hashes\MD5\Enabled:
  reg:
    - present
    - vtype: REG_DWORD
    - value: 0

{% endif %} {# if grains['os_family'] == 'Windows' #}
