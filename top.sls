#### TOP.SLS --- Apply listed SLS modules to the targeted Salt minions

### For more information about the format of this file, see
### http://docs.saltstack.com/en/latest/ref/states/top.html.  For more
### information about change management procedures, see TODO.  The key
### words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
### "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in
### this document are to be interpreted as described in RFC 2119,
### https://tools.ietf.org/html/rfc2119.  The key words "MUST (BUT WE
### KNOW YOU WON'T)", "SHOULD CONSIDER", "REALLY SHOULD NOT", "OUGHT
### TO", "WOULD PROBABLY", "MAY WISH TO", "COULD", "POSSIBLE", and
### "MIGHT" in this document are to be interpreted as described in RFC
### 6919, https://tools.ietf.org/html/rfc6919.  The keywords "DANGER",
### "WARNING", and "CAUTION" in this document are to be interpreted as
### described in OSHA 1910.145,
### https://www.osha.gov/pls/oshaweb/owadisp.show_document?p_table=standards&p_id=9794.

### WARNING: DO NOT ENABLE FORMULAS IN ANY ENVIRONMENT until the
### following conditions have been met:
###   - The formula has been forked (or imported) into the irtnog
###     GitHub organization.
###   - It has been enabled in the "salt_formulas:list" pillar for the
###     correct environment(s).
###   - A highstate job has been run on the Salt master twice, once to
###     clone the formula on the master via the salt.formulas SLS, and
###     again to ensure that the master is configured properly.

### NOTE: Use the "git merge", "git checkout", or "git cherry-pick"
### command to merge approved changes from the development branch into
### the testing, staging, or production branches.  For example, if
### changes to the files in sshd/ are ready for deployment, the
### following will merge them into the staging branch:
###
###   $ git checkout staging
###   $ git checkout testing sshd/init.sls sshd/defaults.yaml sshd/map.jinja
###   $ git commit -m "'Merge' sshd state from 'testing' branch per CR#123"
###
### In another example, if commit aaaa00 is of a file being deleted in
### the development branch, the following will apply that commit to
### testing:
###
###   $ git checkout testing
###   $ git cherry-pick -x aaaa00

####
#### COMMON STATE IDS
####

{% set debian = [
    'salt.pkgrepo',
    'salt.minion',
    'accounting',
    'aliases',
    'auditd',
    'banners',
    'cron',
    'dig',
    'emacs',
    'fail2ban',
    'fail2ban.config',
    'git',
    'kerberos5',
    'man',
    'mosh',
    'mounts',
    'ncurses',
    'nis.client',
    'nfs.client',
    'nmap',
    'ntp.ng',
    'p7zip',
    'pam_mkhomedir',
    'pki',
    'postfix',
    'tcpdump',
    'tcsh',
    'screen',
    'snmp',
    'snmp.conf',
    'ssh',
    'sshd',
    'subversion',
    'sudoers',
    'symlinks',
    'sysctl',
    'tcpdump',
    'tcsh',
    'users',
    'w3m',
  ] %}

{% set freebsd = [
    'poudriere.client',
    'salt.minion',
    'rc',
    'periodic',
    'accounting',
    'aliases',
    'auditd',
    'banners',
    'bash',
    'bgfsck',
    'cron',
    'dig',
    'emacs',
    'fail2ban',
    'fail2ban.config',
    'freebsd-update',
    'git',
    'gnupg',
    'kerberos5',
    'mosh',
    'mounts',
    'moused',
    'ncurses',
    'nfs.client',
    'nis.client',
    'nmap',
    'ntp.ng',
    'p7zip',
    'pam_mkhomedir',
    'pki',
    'postfix',
    'screen',
    'ssh',
    'sshd',
    'subversion',
    'sudoers',
    'symlinks',
    'syscons',
    'sysctl',
    'users',
    'w3m',
  ] %}

{% set redhat = [
    'salt.pkgrepo',
    'salt.minion',
    'hostname',
    'yum',
    'epel',
    'nux.dextop',
    'nux.misc',
    'accounting',
    'aliases',
    'auditd',
    'banners',
    'cron',
    'dig',
    'emacs',
    'fail2ban',
    'fail2ban.config',
    'firewalld',
    'git',
    'kerberos5',
    'man',
    'mosh',
    'mounts',
    'ncurses',
    'net-tools',
    'nfs.client',
    'nis.client',
    'nmap',
    'ntp.ng',
    'p7zip',
    'pam_mkhomedir',
    'pki',
    'postfix',
    'screen',
    'selinux',
    'snmp',
    'snmp.conf',
    'snmp.options',
    'ssh',
    'sshd',
    'subversion',
    'sudoers',
    'symlinks',
    'sysctl',
    'tcpdump',
    'tcsh',
    'users',
    'w3m',
  ] %}

{% set suse = [
    'salt.minion',
    'accounting',
    'aliases',
    'auditd',
    'banners',
    'cron',
    'emacs',
    'git',
    'kerberos5',
    'man',
    'mosh',
    'mounts',
    'ncurses',
    'nfs.client',
    'nis.client',
    'nmap',
    'ntp.ng',
    'p7zip',
    'screen',
    'selinux',
    'snmp',
    'snmp.conf',
    'snmp.options',
    'ssh',
    'sshd',
    'subversion',
    'sudoers',
    'symlinks',
    'sysctl',
    'tcpdump',
    'tcsh',
    'users',
  ] %}

{% set solaris = [
    'accounting',
    'aliases',
    'auditd',
    'banners',
    'cron',
    'emacs',
    'git',
    'kerberos5',
    'mosh',
    'mounts',
    'ncurses',
    'nfs.client',
    'nis.client',
    'nmap',
    'ntp.ng',
    'p7zip',
    'postfix',
    'screen',
    'ssh',
    'sshd',
    'subversion',
    'sudoers',
    'symlinks',
    'tcpdump',
    'tcsh',
    'users',
  ] %}

{% set windows = [
    'salt.minion',
    'csc',
    'git',
    'gpmc',
    'npp',
    'p7zip',
    'perfmon',
    'powershell',
    'rdp',
    'rsat',
    'subversion',
    'users',
    'web-mgmt-tools',
  ] %}

{% set salt_master = [
    'apache',
    'poudriere',
    'salt.cloud',
    'salt.formulas',
    'salt.gitfs.gitpython',
    'salt.master',
    'salt.reactors',
    'salt.ssh',
    'shibboleth.sp',
    'vault',
  ] %}

{% set mail_relay = [
    'amavisd',
    'clamav',
    'clamav.amavisd',
  ] %}

{% set minecraft = [
    'spigotmc',
  ] %}

{% set identity_provider = [
    'apache',
    'openid-ldap',
    'shibboleth.repo',
    'shibboleth.idp.content',
    'shibboleth.mda',
    'shibboleth.mda.content',
    'tomcat.shibboleth-idp',
  ] %}

{% set web_server = [
    'apache',
    'opentracker',
    'shibboleth.sp',
    'trac',
  ] %}

####
#### BASE ENVIRONMENT
####

### Currently, the base environment is not used except for targeting
### (i.e., this file).  This environment corresponds with the master
### branch of this repository.

base:
  '*':
    []                          # no-op

####
#### DEVELOPMENT ENVIRONMENT
####

### The development environment is a sandbox which requires no prior
### change authorization.  Instead, this environment is where system
### administrators must prototype any proposed changes to the
### production environment.

development:
  'I@environment:development and G@os_family:Debian':
    - match: compound
    {%- for sls_id in debian %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:development and G@os_family:FreeBSD':
    - match: compound
    {%- for sls_id in freebsd %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:development and G@os_family:RedHat':
    - match: compound
    {%- for sls_id in redhat %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:development and G@os_family:Suse':
    - match: compound
    {%- for sls_id in suse %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:development and G@os_family:Solaris':
    - match: compound
    {%- for sls_id in solaris %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:development and G@os_family:Windows':
    - match: compound
    {%- for sls_id in windows %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:development and G@virtual:VirtualPC':
    - match: compound
    - hyperv.ic

  'I@environment:development and G@virtual:VMware':
    - match: compound
    - vmware.tools

  'I@environment:development and I@role:salt-master':
    - match: compound
    {%- for sls_id in salt_master %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:development and I@role:mail-relay':
    - match: compound
    {%- for sls_id in mail_relay %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:development and I@role:devstack':
    - match: compound
    - apache
    - mysql
    - mysql.python
    - mysql.remove_test_database
    - rabbitmq
    - rabbitmq.config
    - openstack.repo
    - openstack.keystone

  'I@environment:development and I@role:minecraft':
    - match: compound
    {%- for sls_id in minecraft %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:development and I@role:identity-provider':
    - match: compound
    {%- for sls_id in identity_provider %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:development and I@role:web-server':
    - match: compound
    {%- for sls_id in web_server %}
    - {{ sls_id }}
    {%- endfor %}

####
#### TESTING ENVIRONMENT
####

### The testing environment is for semi-automated, semi-permanent,
### non-production system testing (e.g., performance testing,
### usability testing, stress testing, and so on).

testing:
  'I@environment:testing and G@os_family:Debian':
    - match: compound
    {%- for sls_id in debian %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:testing and G@os_family:FreeBSD':
    - match: compound
    {%- for sls_id in freebsd %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:testing and G@os_family:RedHat':
    - match: compound
    {%- for sls_id in redhat %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:testing and G@os_family:Suse':
    - match: compound
    {%- for sls_id in suse %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:testing and G@os_family:Solaris':
    - match: compound
    {%- for sls_id in solaris %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:testing and G@os_family:Windows':
    - match: compound
    {%- for sls_id in windows %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:testing and G@virtual:VirtualPC':
    - match: compound
    - hyperv.ic

  'I@environment:testing and G@virtual:VMware':
    - match: compound
    - vmware.tools

  'I@environment:testing and I@role:salt-master':
    - match: compound
    {%- for sls_id in salt_master %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:testing and I@role:mail-relay':
    - match: compound
    {%- for sls_id in mail_relay %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:testing and I@role:minecraft':
    - match: compound
    {%- for sls_id in minecraft %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:testing and I@role:identity-provider':
    - match: compound
    {%- for sls_id in identity_provider %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:testing and I@role:web-server':
    - match: compound
    {%- for sls_id in web_server %}
    - {{ sls_id }}
    {%- endfor %}

####
#### STAGING ENVIRONMENT
####

### The staging environment is not used for SLS module targeting;
### instead, it holds any proposed changes to the production
### environment.  After SLS module changes pass system testing, they
### must be merged into the staging environment.  Once merged, these
### changes may be deployed to production servers for final user
### acceptance testing via `state.sls` (with `saltenv` set to
### `staging`).  Only accepted changes may then be merged into the
### production environment.

staging:
  '*':
    []                          # no-op

####
#### PRODUCTION ENVIRONMENT
####

### The production environment reflects the current configuration of
### all user-facing services and related resources.  Should user
### acceptance testing of staged changes fail, production servers may
### be returned to their original configuration by running a highstate
### job.

production:
  'I@environment:production and G@os_family:Debian':
    - match: compound
    {%- for sls_id in debian %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:production and G@os_family:FreeBSD':
    - match: compound
    {%- for sls_id in freebsd %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:production and G@os_family:RedHat':
    - match: compound
    {%- for sls_id in redhat %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:production and G@os_family:Suse':
    - match: compound
    {%- for sls_id in suse %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:production and G@os_family:Solaris':
    - match: compound
    {%- for sls_id in solaris %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:production and G@os_family:Windows':
    - match: compound
    {%- for sls_id in windows %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:production and G@virtual:VirtualPC':
    - match: compound
    - hyperv.ic

  'I@environment:production and G@virtual:VMware':
    - match: compound
    - vmware.tools

  'I@environment:production and I@role:salt-master':
    - match: compound
    {%- for sls_id in salt_master %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:production and I@role:mail-relay':
    - match: compound
    {%- for sls_id in mail_relay %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:production and I@role:minecraft':
    - match: compound
    {%- for sls_id in minecraft %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:production and I@role:identity-provider':
    - match: compound
    {%- for sls_id in identity_provider %}
    - {{ sls_id }}
    {%- endfor %}

  'I@environment:production and I@role:web-server':
    - match: compound
    {%- for sls_id in web_server %}
    - {{ sls_id }}
    {%- endfor %}

#### TOP.SLS ends here.
