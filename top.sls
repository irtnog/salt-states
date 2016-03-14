#### TOP.SLS --- Apply listed SLS modules to the targeted Salt minions

### For more information about the format of this file, see
### http://docs.saltstack.com/en/latest/ref/states/top.html.  For more
### information about change management procedures, see TODO.  The key
### words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
### "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in
### this document are to be interpreted as described in RFC 2119,
### http://www.rfc-editor.org/rfc/rfc2119.txt.  The keywords "DANGER",
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

### NOTE: Use the "git merge" or "git cherry-pick" command to merge
### approved changes from the development branch to the testing,
### staging, or production branches.  For example, if commit aaaa00 is
### of a file being deleted in the development branch, the following
### will apply that commit to testing:
###
###   $ git checkout testing
###   $ git cherry-pick -x aaaa00

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
    - accounting
    - aliases
    - auditd
    - banners
    - cron
    - emacs
    - fail2ban
    - fail2ban.config
    - git
    - kerberos5
    - mosh
    - mounts
    - nis.client
    - nfs.client
    - nmap
    - ntp.ng
    - openssh
    - pam_mkhomedir
    - pki
    - postfix
    - tcpdump
    - tcsh
    - salt.pkgrepo
    - salt.minion
    - screen
    - snmp
    - snmp.conf
    - sudoers
    - symlinks
    - sysctl
    - tcpdump
    - tcsh
    - users

  'I@environment:development and G@os_family:FreeBSD':
    - match: compound
    - poudriere.client          # local pkgng repo
    - rc
    - periodic
    - accounting
    - aliases
    - auditd
    - banners
    - bgfsck
    - cron
    - emacs
    - fail2ban
    - fail2ban.config
    - git
    - kerberos5
    - mosh
    - mounts
    - moused
    - nfs.client
    - nis.client
    - nmap
    - ntp.ng
    - openssh
    - pam_mkhomedir
    - pki
    - postfix
    - salt.minion
    - screen
    - sudoers
    - symlinks
    - syscons
    - sysctl
    - users

  'I@environment:development and G@os_family:RedHat':
    - match: compound
    - hostname
    - yum
    - epel
    - nux.dextop                # requires EPEL
    - nux.misc
    - accounting
    - aliases
    - auditd
    - banners
    - cron
    - emacs
    - fail2ban
    - fail2ban.config
    - git
    - kerberos5
    - mosh
    - mounts
    - nfs.client
    - nis.client
    - nmap
    - ntp.ng
    - openssh
    - pam_mkhomedir
    - pki
    - postfix
    - salt.pkgrepo
    - salt.minion
    - screen
    - selinux
    - snmp
    - snmp.conf
    - snmp.options
    - sudoers
    - symlinks
    - sysctl
    - tcpdump
    - tcsh
    - users

  'I@environment:development and G@os_family:Suse':
    - match: compound
    - accounting
    - aliases
    - auditd
    - banners
    - cron
    - emacs
    # - fail2ban
    # - fail2ban.config
    - git
    - kerberos5
    - man
    - mosh
    - mounts
    - nfs.client
    - nis.client
    - nmap
    - ntp.ng
    - openssh
    - salt.minion
    - screen
    - selinux
    - snmp
    - snmp.conf
    - snmp.options
    - sudoers
    - symlinks
    - sysctl
    - tcpdump
    - tcsh
    - users

  'I@environment:development and G@os_family:Solaris':
    - match: compound
    - accounting
    - aliases
    - auditd
    - banners
    - cron
    - emacs
    - git
    - kerberos5
    - mosh
    - mounts
    - nfs.client
    - nis.client
    - nmap
    - ntp.ng
    - postfix
    - screen
    - sudoers
    - symlinks
    - tcpdump
    - tcsh
    - users

  'I@environment:development and G@os_family:Windows':
    - match: compound
    - git
    - gpmc
    - powershell
    - rdp
    - rsat
    - salt.minion
    - schannel
    - users
    - web-mgmt-tools

  'I@environment:development and G@virtual:VirtualPC':
    - match: compound
    - hyperv.guest

  'I@environment:development and I@role:salt-master':
    - match: compound
    - apache
    - salt.cloud
    - salt.formulas
    - salt.gitfs.gitpython
    - salt.reactors
    - salt.master
    - salt.ssh
    - poudriere

  'I@environment:development and I@role:mail-relay':
    - match: compound
    - amavisd
    - clamav
    - clamav.amavisd

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
    - spigotmc

####
#### TESTING ENVIRONMENT
####

### The testing environment is for semi-automated, semi-permanent,
### non-production system testing (e.g., performance testing,
### usability testing, stress testing, and so on).

testing:
  'I@environment:testing and G@os_family:Debian':
    - match: compound
    - accounting
    - aliases
    - auditd
    - banners
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - kerberos5
    - mosh
    - mounts
    - nis.client
    - nfs.client
    - ntp.ng
    - openssh
    - pam_mkhomedir
    - pki
    - postfix
    - tcsh
    - salt.pkgrepo
    - salt.minion
    - screen
    - snmp
    - snmp.conf
    - sudoers
    - symlinks
    - sysctl
    - users

  'I@environment:testing and G@os_family:FreeBSD':
    - match: compound
    - poudriere.client          # local pkgng repo
    - rc
    - periodic
    - accounting
    - aliases
    - auditd
    - banners
    - bgfsck
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - kerberos5
    - mosh
    - mounts
    - moused
    - nfs.client
    - nis.client
    - ntp.ng
    - openssh
    - pam_mkhomedir
    - pki
    - postfix
    - salt.minion
    - screen
    - sudoers
    - symlinks
    - syscons
    - sysctl
    - users

  'I@environment:testing and G@os_family:RedHat':
    - match: compound
    - hostname
    - yum
    - epel
    - nux.dextop                # requires EPEL
    - nux.misc
    - accounting
    - aliases
    - auditd
    - banners
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - kerberos5
    - mosh
    - mounts
    - nfs.client
    - nis.client
    - ntp.ng
    - openssh
    - pam_mkhomedir
    - pki
    - postfix
    - salt.pkgrepo
    - salt.minion
    - screen
    - selinux
    - snmp
    - snmp.conf
    - snmp.options
    - sudoers
    - symlinks
    - sysctl
    - tcsh
    - users

  'I@environment:testing and G@os_family:Windows':
    - match: compound
    - git
    - gpmc
    - powershell
    - rsat
    - salt.minion
    - schannel
    - users
    - web-mgmt-tools

  'I@environment:testing and I@role:salt-master':
    - match: compound
    - apache
    - salt.cloud
    - salt.formulas
    - salt.reactors
    - salt.gitfs.gitpython
    - salt.master
    - salt.ssh
    - poudriere

  'I@environment:testing and I@role:mail-relay':
    - match: compound
    - amavisd
    - clamav
    - clamav.amavisd

  'I@environment:testing and I@role:minecraft':
    - match: compound
    - spigotmc

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
    - accounting
    - aliases
    - auditd
    - banners
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - kerberos5
    - mosh
    - mounts
    - nis.client
    - nfs.client
    - ntp.ng
    - openssh
    - pam_mkhomedir
    - pki
    - postfix
    - tcsh
    - salt.pkgrepo
    - salt.minion
    - screen
    - snmp
    - snmp.conf
    - sudoers
    - symlinks
    - sysctl
    - users

  'I@environment:production and G@os_family:FreeBSD':
    - match: compound
    - poudriere.client          # local pkgng repo
    - rc
    - periodic
    - accounting
    - aliases
    - auditd
    - banners
    - bgfsck
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - kerberos5
    - mosh
    - mounts
    - moused
    - nfs.client
    - nis.client
    - ntp.ng
    - openssh
    - pam_mkhomedir
    - pki
    - postfix
    - salt.minion
    - screen
    - sudoers
    - symlinks
    - syscons
    - sysctl
    - users

  'I@environment:production and G@os_family:RedHat':
    - match: compound
    - hostname
    - yum
    - epel
    - nux.dextop                # requires EPEL
    - nux.misc
    - accounting
    - aliases
    - auditd
    - banners
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - kerberos5
    - mosh
    - mounts
    - nfs.client
    - nis.client
    - ntp.ng
    - openssh
    - pam_mkhomedir
    - pki
    - postfix
    - salt.pkgrepo
    - salt.minion
    - screen
    - selinux
    - snmp
    - snmp.conf
    - snmp.options
    - sudoers
    - symlinks
    - sysctl
    - tcsh
    - users

  'I@environment:production and G@os_family:Windows':
    - match: compound
    - git
    - gpmc
    - powershell
    - rsat
    - salt.minion
    - schannel
    - users
    - web-mgmt-tools

  'I@environment:production and I@role:salt-master':
    - match: compound
    - apache
    - salt.cloud
    - salt.formulas
    - salt.reactors
    - salt.gitfs.gitpython
    - salt.master
    - salt.ssh
    - poudriere

  'I@environment:production and I@role:mail-relay':
    - match: compound
    - amavisd
    - clamav
    - clamav.amavisd

  'I@environment:production and I@role:minecraft':
    - match: compound
    - spigotmc

#### TOP.SLS ends here.
