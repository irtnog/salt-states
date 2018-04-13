install_asp_net:
  dism.feature_installed:
    - names:
        - IIS-ASPNET45
        - IIS-ApplicationDevelopment
        - IIS-CommonHttpFeatures
        - IIS-DefaultDocument
        - IIS-DirectoryBrowsing
        - IIS-HealthAndDiagnostics
        - IIS-HttpCompressionStatic
        - IIS-HttpErrors
        - IIS-HttpLogging
        - IIS-HttpRedirect
        - IIS-IIS6ManagementCompatibility
        - IIS-ISAPIExtensions
        - IIS-ISAPIFilter
        - IIS-ManagementConsole
        - IIS-Metabase
        - IIS-NetFxExtensibility45
        - IIS-Performance
        - IIS-RequestFiltering
        - IIS-Security
        - IIS-StaticContent
        - IIS-WebServer
        - IIS-WebServerManagementTools
        - IIS-WebServerRole
        - NetFx4Extended-ASPNET45
    - enable_parent: True
    - restart: False

install_acmesharp:
  cmd.run:
    - name: |
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force;
        Install-Module ACMESharp -Force;
        Install-Module ACMESharp.Providers.IIS -Force;
        Import-Module ACMESharp;
        Enable-ACMEExtensionModule ACMESharp.Providers.IIS;
        Initialize-ACMEVault;
        New-ACMERegistration -Contacts mailto:webmaster@irtnog.org -AcceptTos;
        New-ACMEIdentifier -Dns {{ grains['public_fqdn'] }} -Alias training;
        Complete-ACMEChallenge -IdentifierRef training -ChallengeType http-01 -Handler iis -HandlerParameters @{ WebSiteRef = 'Default Web Site' };
        Submit-ACMEChallenge -IdentifierRef training -ChallengeType http-01;
        sleep -s 60;
        Update-ACMEIdentifier -IdentifierRef training;
        New-ACMECertificate -Generate -IdentifierRef training -Alias training;
        Submit-ACMECertificate -CertificateRef training;
        Update-ACMECertificate -CertificateRef training;
        Install-ACMECertificate -CertificateRef training -Installer iis -InstallerParameters @{ WebSiteRef = 'Default Web Site' }
    - shell: powershell
    - require:
        - dism: install_asp_net

download_shibboleth:
  file.managed:
    - name: 'C:\shibboleth-sp-2.6.0.1-win64.msi'
    - source: https://shibboleth.net/downloads/service-provider/2.6.0/win64/shibboleth-sp-2.6.0.1-win64.msi
    - source_hash: sha256=00dced1a41997305827e5f3f6a308ed1cf6ca79dd3c3f961dedd63b4e316e68c
