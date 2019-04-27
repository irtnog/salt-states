{%- set certfp = salt['pillar.get']('rds:gateway:certificate') %}
{%- if certfp %}
rds_gateway_certificate:
  cmd.run:
    - shell: powershell
    - name:
        Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force;
        Import-Module RemoteDesktopServices;
        Set-Item -Path "RDS:\GatewayServer\SSLCertificate\Thumbprint" {{ certfp }}

  module.run:
    - name: service.restart
    - m_name: TSGateway
    - require:
        - cmd: rds_gateway_certificate
{%- endif %}
