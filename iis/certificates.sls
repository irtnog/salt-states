{%- for site, site_settings in salt['pillar.get']('iis:sites', {})|dictsort %}
{%-   for name, binding in site_settings['bindings']|default({})|dictsort
      if binding['protocol']|default('https') == 'https' %}
{{ 'iis_certificates_%s_%s'|format(site, name)|yaml_encode }}:
  cmd.run:
    - shell: powershell
    - name:
        Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force;
        Import-Module WebAdministration;
        (Get-WebBinding -Name "{{ site }}"
            -Protocol https
            -IPAddress {{ binding['ip_address']|default('*') }}
            -Port {{ binding['port']|default(443) }}
        ).AddSslCertificate("{{ binding['certificate'] }}", "my")
{%-   endfor %}
{%- endfor %}
