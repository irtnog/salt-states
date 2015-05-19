#### TOP.SLS --- Apply listed SLS modules to the targeted Salt minions

### For more information about the format of this file, see
### http://docs.saltstack.com/en/latest/ref/states/top.html.  For more
### information about change management procedures, see TODO.  The key
### words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
### "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in
### this document are to be interpreted as described in RFC 2119,
### http://www.rfc-editor.org/rfc/rfc2119.txt.

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
  'I@environment:development':
    - match: compound
    - accounting
    - aliases
    - auditd
    - banners
    - bgfsck
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - hyperv
    - lockd
    - mounts
    - moused
    - nfsclient
    - ntp.ng
    - pam_krb5
    - periodic
    - pki
    - postfix
    - postfix.config
    - poudriere.client
    - rc
    - rpcbind
    - salt.minion
    - schannel
    - snmp
    - snmp.conf
    - snmp.options
    - statd
    - sudoers
    - sysctl
    - syscons
    - users

  'I@environment:development and G@os_family:RedHat':
    - match: compound
    - epel
    - nux.dextop                # requires EPEL
    - nux.misc

  'I@environment:development and I@role:salt-master':
    - match: compound
    - apache
    - apache.modules
    - apache.mod_wsgi
    - salt.api
    - salt.cloud
    - salt.formulas
    - salt.gitfs.pygit2
    - salt.master
    - salt.ssh
    - poudriere

  'I@environment:development and I@role:devstack':
    - match: compound
    - apache
    - apache.modules
    - apache.mod_wsgi
    - mysql
    - mysql.python
    - mysql.remove_test_database
    - rabbitmq
    - rabbitmq.config
    - openstack.repo

####
#### TESTING ENVIRONMENT
####

### The testing environment is for semi-automated non-production
### functional, performance, or quality assurance testing.  This
### environment corresponds with the testing branch of this
### repository.

testing:
  'I@environment:testing':
    - match: compound
    - accounting
    - aliases
    - auditd
    - banners
    - bgfsck
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - hyperv
    - lockd
    - mounts
    - moused
    - nfsclient
    - ntp.ng
    - pam_krb5
    - periodic
    - pki
    - postfix
    - postfix.config
    - poudriere.client
    - rc
    - rpcbind
    - salt.minion
    - schannel
    - snmp
    - snmp.conf
    - snmp.options
    - statd
    - sudoers
    - sysctl
    - syscons
    - users

  'I@environment:testing and G@os_family:RedHat':
    - match: compound
    - epel
    - nux.dextop                # requires EPEL
    - nux.misc

  'I@environment:testing and I@role:salt-master':
    - match: compound
    - apache
    - apache.modules
    - apache.mod_wsgi
    - salt.api
    - salt.cloud
    - salt.formulas
    - salt.gitfs.pygit2
    - salt.master
    - salt.ssh
    - poudriere

####
#### STAGING ENVIRONMENT
####

### The staging environment is for pre-production user acceptance
### testing.  Any changes to SLS modules or SLS targeting in this
### environment require Change Advisory Board approval.  This
### environment corresponds with the staging branch of this
### repository.

staging:
  'I@environment:staging':
    - match: compound
    - accounting
    - aliases
    - auditd
    - banners
    - bgfsck
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - hyperv
    - lockd
    - mounts
    - moused
    - nfsclient
    - ntp.ng
    - pam_krb5
    - periodic
    - pki
    - postfix
    - postfix.config
    - poudriere.client
    - rc
    - rpcbind
    - salt.minion
    - schannel
    - snmp
    - snmp.conf
    - snmp.options
    - statd
    - sudoers
    - sysctl
    - syscons
    - users

  'I@environment:staging and G@os_family:RedHat':
    - match: compound
    - epel
    - nux.dextop                # requires EPEL
    - nux.misc

  'I@environment:staging and I@role:salt-master':
    - match: compound
    - apache
    - apache.modules
    - apache.mod_wsgi
    - salt.api
    - salt.cloud
    - salt.formulas
    - salt.gitfs.pygit2
    - salt.master
    - salt.ssh
    - poudriere

####
#### PRODUCTION ENVIRONMENT
####

### The production environment includes all user-facing services and
### related resources.  Any changes to SLS modules or SLS targeting in
### this environment require Change Advisory Board approval.  This
### environment corresponds with the production branch of this
### repository.

production:
  'I@environment:production':
    - match: compound
    - accounting
    - aliases
    - auditd
    - banners
    - bgfsck
    - cron
    - fail2ban
    - fail2ban.config
    - git
    - hyperv
    - lockd
    - mounts
    - moused
    - nfsclient
    - ntp.ng
    - pam_krb5
    - periodic
    - pki
    - postfix
    - postfix.config
    - poudriere.client
    - rc
    - rpcbind
    - salt.minion
    - schannel
    - snmp
    - snmp.conf
    - snmp.options
    - statd
    - sudoers
    - sysctl
    - syscons
    - users

  'I@environment:production and G@os_family:RedHat':
    - match: compound
    - epel
    - nux.dextop                # requires EPEL
    - nux.misc

  'I@environment:production and I@role:salt-master':
    - match: compound
    - apache
    - apache.modules
    - apache.mod_wsgi
    - salt.api
    - salt.cloud
    - salt.formulas
    - salt.gitfs.pygit2
    - salt.master
    - salt.ssh
    - poudriere

  'I@environment:production and I@role:minecraft':
    - match: compound
    - spigotmc

#### TOP.SLS ends here.
