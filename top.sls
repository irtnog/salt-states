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

### NOTE: Use the "git checkout" command to merge approved changes
### from the development branch to the testing, staging, or production
### branches.  Make sure to include the approved change request ID in
### the commit message.  For example, the following commands would
### merge the development version of the "salt" directory (including
### its subdirectories) with the testing branch:
###
###   $ git checkout testing
###   $ git checkout development salt
###   $ git commit -m "Begin testing modified Salt config per CR#1234"
###
### To merge file/directory deletions, use the "git cherry-pick"
### command.  For example, if commit aaaa00 is of a file being
### deleted in the development branch, the following will apply that
### commit to testing:
###
###   $ git checkout testing
###   $ git cherry-pick -x aaaa00
###
### In both cases the changelog and commit messages will be imported
### into the target branch.

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
### production environment.  This environment corresponds with the
### development branch of this repository.

development:
  'I@environment:development and G@os_family:Debian':
    - match: compound
    - salt.minion               # general settings
    - accounting
    - auditd
    - banners
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - sysctl
    - tcsh
    - rpcbind                   # NFS client
    - amd
    - lockd
    - statd
    - mounts
    - symlinks
    - pki                       # domain membership
    - kerberos5
    - ypbind
    - pam_mkhomedir
    - postfix                   # email
    - aliases

  'I@environment:development and G@os_family:FreeBSD':
    - match: compound
    - poudriere.client          # local pkgng repo
    - accounting
    - aliases
    - amd
    - auditd
    - banners
    - bgfsck
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - hyperv.guest
    - lockd
    - mounts
    - moused
    - nfsclient
    - ntp.ng
    - kerberos5
    - periodic
    - pki
    - postfix
    - rc
    - rpcbind
    - salt.minion
    - snmp
    - snmp.conf
    - snmp.options
    - statd
    - sudoers
    - symlinks
    - sysctl
    - syscons
    - users
    - ypbind

  'I@environment:development and G@os_family:RedHat':
    - match: compound
    - epel
    - nux.dextop                # requires EPEL
    - nux.misc
    - accounting
    - aliases
    - amd
    - auditd
    - banners
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - hyperv.guest
    - kerberos5
    - lockd
    - mounts
    - nfsclient
    - ntp.ng
    - pam_mkhomedir
    - pki
    - postfix
    - rpcbind
    - salt.minion
    - selinux
    - snmp
    - snmp.conf
    - snmp.options
    - statd
    - sudoers
    - symlinks
    - sysctl
    - tcsh
    - users
    - ypbind

  'I@environment:development and G@os_family:Windows':
    - match: compound
    - git
    - gpmc
    - powershell
    - rsat
    - salt.minion
    - schannel
    - users
    - web-mgmt-tools

  'I@environment:development and I@role:salt-master':
    - match: compound
    - apache
    - salt.cloud
    - salt.formulas
    - salt.gitfs.gitpython
    - salt.master
    - salt.ssh
    - poudriere

  'I@environment:development and I@role:mail-relay':
    - match: compound
    - amavisd
    - clamav

  'I@environment:development and I@role:devstack':
    - match: compound
    - apache
    - mysql
    - mysql.python
    - mysql.remove_test_database
    - rabbitmq
    - rabbitmq.config
    - openstack.repo

  'I@environment:development and I@role:minecraft':
    - match: compound
    - spigotmc

####
#### TESTING ENVIRONMENT
####

### The testing environment is for semi-automated non-production
### functional, performance, or quality assurance testing.  This
### environment corresponds with the testing branch of this
### repository.

testing:
  'I@environment:testing and G@os_family:FreeBSD':
    - match: compound
    - poudriere.client          # local pkgng repo
    - accounting
    - aliases
    - amd
    - auditd
    - banners
    - bgfsck
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - hyperv.guest
    - lockd
    - mounts
    - moused
    - nfsclient
    - ntp.ng
    - kerberos5
    - periodic
    - pki
    - postfix
    - rc
    - rpcbind
    - salt.minion
    - snmp
    - snmp.conf
    - snmp.options
    - statd
    - sudoers
    - symlinks
    - sysctl
    - syscons
    - users
    - ypbind

  'I@environment:testing and G@os_family:RedHat':
    - match: compound
    - epel
    - nux.dextop                # requires EPEL
    - nux.misc
    - accounting
    - aliases
    - amd
    - auditd
    - banners
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - hyperv.guest
    - kerberos5
    - lockd
    - mounts
    - nfsclient
    - ntp.ng
    - pam_mkhomedir
    - pki
    - postfix
    - rpcbind
    - salt.minion
    - selinux
    - snmp
    - snmp.conf
    - snmp.options
    - statd
    - sudoers
    - symlinks
    - sysctl
    - tcsh
    - users
    - ypbind

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
    - salt.gitfs.gitpython
    - salt.master
    - salt.ssh
    - poudriere

  'I@environment:testing and I@role:mail-relay':
    - match: compound
    - amavisd
    - clamav

  'I@environment:testing and I@role:devstack':
    - match: compound
    - apache
    - mysql
    - mysql.python
    - mysql.remove_test_database
    - rabbitmq
    - rabbitmq.config
    - openstack.repo

  'I@environment:testing and I@role:minecraft':
    - match: compound
    - spigotmc

####
#### STAGING ENVIRONMENT
####

### The staging environment is for pre-production user acceptance
### testing.  Any changes to SLS modules or SLS targeting in this
### environment require Change Advisory Board approval.  This
### environment corresponds with the staging branch of this
### repository.

staging:
  'I@environment:staging and G@os_family:FreeBSD':
    - match: compound
    - poudriere.client          # local pkgng repo
    - accounting
    - amd
    - aliases
    - auditd
    - banners
    - bgfsck
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - hyperv.guest
    - lockd
    - mounts
    - moused
    - nfsclient
    - ntp.ng
    - kerberos5
    - periodic
    - pki
    - postfix
    - rc
    - rpcbind
    - salt.minion
    - snmp
    - snmp.conf
    - snmp.options
    - statd
    - sudoers
    - symlinks
    - sysctl
    - syscons
    - users
    - ypbind

  'I@environment:staging and G@os_family:RedHat':
    - match: compound
    - epel
    - nux.dextop                # requires EPEL
    - nux.misc
    - accounting
    - aliases
    - amd
    - auditd
    - banners
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - hyperv.guest
    - kerberos5
    - lockd
    - mounts
    - nfsclient
    - ntp.ng
    - pam_mkhomedir
    - pki
    - postfix
    - rpcbind
    - salt.minion
    - selinux
    - snmp
    - snmp.conf
    - snmp.options
    - statd
    - sudoers
    - symlinks
    - sysctl
    - tcsh
    - users
    - ypbind

  'I@environment:staging and G@os_family:Windows':
    - match: compound
    - git
    - gpmc
    - powershell
    - rsat
    - salt.minion
    - schannel
    - users
    - web-mgmt-tools

  'I@environment:staging and I@role:salt-master':
    - match: compound
    - apache
    - salt.cloud
    - salt.formulas
    - salt.gitfs.gitpython
    - salt.master
    - salt.ssh
    - poudriere

  'I@environment:staging and I@role:mail-relay':
    - match: compound
    - amavisd
    - clamav

  'I@environment:staging and I@role:devstack':
    - match: compound
    - apache
    - mysql
    - mysql.python
    - mysql.remove_test_database
    - rabbitmq
    - rabbitmq.config
    - openstack.repo

  'I@environment:staging and I@role:minecraft':
    - match: compound
    - spigotmc

####
#### PRODUCTION ENVIRONMENT
####

### The production environment includes all user-facing services and
### related resources.  Any changes to SLS modules or SLS targeting in
### this environment require Change Advisory Board approval.  This
### environment corresponds with the production branch of this
### repository.

production:
  'I@environment:production and G@os_family:FreeBSD':
    - match: compound
    - poudriere.client          # local pkgng repo
    - accounting
    - aliases
    - amd
    - auditd
    - banners
    - bgfsck
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - hyperv.guest
    - lockd
    - mounts
    - moused
    - nfsclient
    - ntp.ng
    - kerberos5
    - periodic
    - pki
    - postfix
    - rc
    - rpcbind
    - salt.minion
    - snmp
    - snmp.conf
    - snmp.options
    - statd
    - sudoers
    - symlinks
    - sysctl
    - syscons
    - users
    - ypbind

  'I@environment:production and G@os_family:RedHat':
    - match: compound
    - epel
    - nux.dextop                # requires EPEL
    - nux.misc
    - accounting
    - aliases
    - amd
    - auditd
    - banners
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - hyperv.guest
    - kerberos5
    - lockd
    - mounts
    - nfsclient
    - ntp.ng
    - pam_mkhomedir
    - pki
    - postfix
    - rpcbind
    - salt.minion
    - selinux
    - snmp
    - snmp.conf
    - snmp.options
    - statd
    - sudoers
    - symlinks
    - sysctl
    - tcsh
    - users
    - ypbind

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
    - salt.gitfs.gitpython
    - salt.master
    - salt.ssh
    - poudriere

  'I@environment:production and I@role:mail-relay':
    - match: compound
    - amavisd
    - clamav

  'I@environment:production and I@role:devstack':
    - match: compound
    - apache
    - mysql
    - mysql.python
    - mysql.remove_test_database
    - rabbitmq
    - rabbitmq.config
    - openstack.repo

  'I@environment:production and I@role:minecraft':
    - match: compound
    - spigotmc

#### TOP.SLS ends here.
