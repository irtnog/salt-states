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
###   $ git commit -m "Begin testing modified Salt config per #1234"
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
### production environment.

development:
  'I@environment:development and G@os_family:Debian':
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
    - mounts
    - nis.client
    - nfs.client
    - ntp.ng
    - openssh
    - pam_mkhomedir
    - pki
    - postfix
    - tcsh
    - salt.minion
    - snmp
    - snmp.conf
    - snmp.options
    - sudoers
    - symlinks
    - sysctl
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
    - fail2ban
    - fail2ban.config
    - git
    - kerberos5
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
    - snmp
    - snmp.conf
    - snmp.options
    - sudoers
    - symlinks
    - syscons
    - sysctl
    - users

  'I@environment:development and G@os_family:RedHat':
    - match: compound
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
    - mounts
    - nfs.client
    - ntp.ng
    - openssh
    - pam_mkhomedir
    - pki
    - postfix
    - salt.minion
    - selinux
    - snmp
    - snmp.conf
    - snmp.options
    - sudoers
    - symlinks
    - sysctl
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

### The testing environment is for semi-automated, semi-permanent,
### non-production system testing (e.g., performance testing,
### usability testing, stress testing, and so on).

testing:
  'I@environment:testing and G@os_family:Debian':
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
    ## NOTE: in-kernel lockd
    - statd
    - mounts
    - symlinks
    - pki                       # domain membership
    - kerberos5
    - ypbind
    - pam_mkhomedir
    - postfix                   # email
    - aliases

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
    ## NOTE: in-kernel lockd
    - statd
    - mounts
    - symlinks
    - pki                       # domain membership
    - kerberos5
    - ypbind
    - pam_mkhomedir
    - postfix                   # email
    - aliases

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
    # - amavisd
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
