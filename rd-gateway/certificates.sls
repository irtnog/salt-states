{%- set certfp = salt['pillar.get']('rds:gateway:certificate') %}
{%- if certfp %}
rd_gateway_certificates:
  cmd.run:
    - shell: powershell
    - name:
        Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force;
        Import-Module RemoteDesktopServices;
        Set-Item -Path "RDS:\GatewayServer\SSLCertificate\Thumbprint" {{ certfp }}
{%- endif %}
