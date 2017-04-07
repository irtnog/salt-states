{%- if grains['os_family'] == 'FreeBSD' %}
## On FreeBSD we use WinRM to perform Windows deployments on EC2.

salt_cloud_deps:
  pkg.installed:
    - pkgs:
        - py27-boto             # devel/py-boto
        - py27-boto3            # www/py-boto3
        - py27-pip              # devel/py-pip
        - py27-openssl          # security/py-openssl
        - py27-ordereddict      # devel/py-ordereddict
        - py27-requests         # www/py-requests
        - py27-requests-kerberos # security/py-requests-kerberos
        - py27-six              # devel/py-six
        - py27-impacket         # net/py-impacket
        - samba44               # net/samba44

  pip.installed:
    - names:
        - ntlm-auth             # https://pypi.python.org/pypi/ntlm-auth
        - requests_ntlm         # https://pypi.python.org/pypi/requests_ntlm
        - requests-credssp      # https://pypi.python.org/pypi/requests-credssp
        - pywinrm               # https://pypi.python.org/pypi/pywinrm

  file.managed:
    - name: /usr/local/etc/salt/windows-firewall.ps1
    - source: salt://salt/files/windows-firewall-winrm.ps1

{%- elif grains['os_family'] == 'RedHat' %}
## On RHEL/CentOS we use SMB to perform Windows deployments on EC2

salt_cloud_deps:
  pkg.installed:
    - pkgs:
        - python-impacket
        - samba-client
        - winexe

  file.managed:
    - name: /etc/salt/windows-firewall.ps1
    - source: salt://salt/files/windows-firewall.ps1

{%- endif %}
