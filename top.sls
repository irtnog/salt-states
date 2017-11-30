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

### Use the "git merge", "git checkout", or "git cherry-pick" command
### to merge approved changes from the development branch into the
### testing, staging, or production branches.  For example, if changes
### to the files in sshd/ are ready for deployment, the following will
### merge them into the staging branch:
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
  'I@environment:development and G@os_family:Debian': &debian
    - match: compound
    - salt.pkgrepo
    - salt.minion
    - shibboleth.repo
    - accounting
    - aliases
    - auditd
    - aws.cli
    - banners
    - boto
    - cron
    - cvs
    - dig
    - dos2unix
    - emacs
    - fail2ban
    - fail2ban.config
    - fonts
    - git
    - irssi
    - kerberos5
    - man
    - mosh
    - mounts
    - ncurses
    - nis.client
    - nfs.client
    - nmap
    - ntp.ng
    - p7zip
    - pam_mkhomedir
    - pki
    - postfix
    - screen
    - sched.patch
    - snmp
    - snmp.conf
    - ssh
    - sshd
    - subversion
    - sudoers
    - symlinks
    - sysctl
    - systemd
    - tcpdump
    - tcsh
    - users
    - w3m

  'I@environment:development and G@os_family:FreeBSD': &freebsd
    - match: compound
    - poudriere.client
    - ca_root_nss
    - salt.minion
    - rc
    - periodic
    - accounting
    - aliases
    - auditd
    - aws.cli
    - banners
    - bash
    - bgfsck
    - boto
    - coreutils
    - cron
    - cvs
    - dig
    - dos2unix
    - emacs
    - fail2ban
    - fail2ban.config
    - fonts
    - freebsd-update
    - git
    - gnupg
    - irssi
    - kerberos5
    - mosh
    - mounts
    - moused
    - ncurses
    - nfs.client
    - nis.client
    - nmap
    - ntp.ng
    - p7zip
    - pam_mkhomedir
    - pki
    - portsnap
    - postfix
    - sched.patch
    - screen
    - ssh
    - sshd
    - subversion
    - sudoers
    - symlinks
    - syscons
    - sysctl
{#- Enable the ufw SLS on minions not running in AWS. #}
{%- if not salt.grains.get('biosversion', '').endswith('amazon') %}
    - ufw
{%- endif %}
    - users
    - w3m

  'I@environment:development and G@os_family:RedHat': &redhat
    - match: compound
    - salt.pkgrepo
    - salt.minion
    - hostname
    - yum
    - epel
    - nux.dextop
    - nux.misc
    - scl
    - shibboleth.repo
    - accounting
    - aliases
    - auditd
    - aws.cli
    - banners
    - boto
    - cron
    - cvs
    - dig
    - dos2unix
    - emacs
    - fail2ban
    - fail2ban.config
{#- Enable the firewalld SLS on minions not running in AWS. #}
{%- if not salt.grains.get('biosversion', '').endswith('amazon') %}
    - firewalld
{%- endif %}
    - fonts
    - git
    - irssi
    - kerberos5
    - man
    - mosh
    - mounts
    - ncurses
    - net-tools
    - nfs.client
    - nis.client
    - nmap
    - ntp.ng
    - p7zip
    - pam_mkhomedir
    - pki
    - postfix
    - sched.patch
    - screen
    - selinux
    - snmp
    - snmp.conf
    - snmp.options
    - ssh
    - sshd
    - subversion
    - sudoers
    - symlinks
    - sysctl
    - systemd
    - tcpdump
    - tcsh
    - users
    - w3m

  'I@environment:development and G@os_family:Suse': &suse
    - match: compound
    - salt.minion
    - shibboleth.repo
    - accounting
    - aliases
    - auditd
    - aws.cli
    - banners
    - boto
    - cron
    - cvs
    - emacs
    - fonts
    - git
    - irssi
    - kerberos5
    - man
    - mosh
    - mounts
    - ncurses
    - nfs.client
    - nis.client
    - nmap
    - ntp.ng
    - p7zip
    - screen
    - selinux
    - snmp
    - snmp.conf
    - snmp.options
    - ssh
    - sshd
    - subversion
    - sudoers
    - symlinks
    - sysctl
    - systemd
    - tcpdump
    - tcsh
    - users

  'I@environment:development and G@os_family:Solaris': &solaris
    - match: compound
    - accounting
    - aliases
    - auditd
    - banners
    - cron
    - emacs
    - git
    - irssi
    - kerberos5
    - mosh
    - mounts
    - ncurses
    - nfs.client
    - nis.client
    - nmap
    - ntp.ng
    - p7zip
    - postfix
    - screen
    - ssh
    - sshd
    - subversion
    - sudoers
    - symlinks
    - tcpdump
    - tcsh
    - users

  'I@environment:development and G@os_family:Windows': &windows
    - match: compound
    - salt.minion
    - aws.cli
    - desktop.cleanup
    - merakism.agent
    - npp
    - p7zip
    - perfmon
    - powershell
    - putty
    - rdp
    - tightvnc
    - users
    - winsnmp

  'I@environment:development and G@os_family:Windows and J@role:^(desktop|laptop)$': &windowsgui
    - match: compound
    - adobe
    - chrome
    - csc
    - fiddler
    - git
    - gpmc
    - firefox
    - fonts
    - itunes
    - rsat
    - steam
    - subversion
    - terminals
    - web-mgmt-tools

  'I@environment:development and G@virtual:VirtualPC': &virtualpc
    - match: compound
    - hyperv.ic

  'I@environment:development and G@virtual:VMware': &vmwareguest
    - match: compound
    - vmware.tools

  'I@environment:development and I@role:salt-master': &saltmaster
    - match: compound
    - salt.formulas
    - salt.gitfs.gitpython
    - salt.master
    - salt.cloud.ext
    - saltpad
    - shibboleth.sp
    - apache
    - apache.config
    - apache.mod_rewrite
    - apache.mod_shib
    - apache.mod_socache_shmcb
    - apache.mod_ssl
    - apache.mod_wsgi
    - apache.vhosts.standard
    - letsencrypt
    - poudriere
    - aws.iam
    - aws.s3
    - aws.vpc
    - aws.lambda
    - salt.cloud
    - salt.ssh
    - vault

  'I@environment:development and I@role:mail-relay': &mailrelay
    - match: compound
    - clamav.amavisd

  'I@environment:development and I@role:minecraft': &minecraft
    - match: compound
    - spigotmc

  'I@environment:development and I@role:identity-provider': &identityprovider
    - match: compound
    - php.ng
    - php.ng.cli
    - php.ng.ldap
    - php.ng.mbstring
    - php.ng.mysql
    - php.ng.xml
    - mysql
    - shibboleth.sp
    - apache
    - apache.config
    - apache.mod_proxy
    - apache.mod_proxy_http
    - apache.mod_rewrite
    - apache.mod_shib
    - apache.mod_ssl
    - apache.vhosts.standard
    - apache.content.idp_branding
    - letsencrypt
    - slapd
    - irtnog-co.openldap-provider
    - comanage.registry
    - openid-ldap
    - shibboleth.mda
    - tomcat.pwm
    - tomcat.shibboleth-idp

  'I@environment:development and I@role:web-server': &webserver
    - match: compound
    - shibboleth.sp
    - apache
    - apache.config
    - apache.mod_proxy
    - apache.mod_proxy_http
    - apache.mod_rewrite
    - apache.mod_shib
    - apache.mod_socache_shmcb
    - apache.mod_ssl
    - apache.mod_wsgi
    - apache.vhosts.standard
    - letsencrypt
    - opentracker
    - trac

  'I@environment:development and I@role:comanage-registry': &comanageregistry
    - match: compound
    - apache
    - letsencrypt
    - comanage.registry
    - shibboleth.sp

  'I@environment:development and I@role:perfsonar': &perfsonar
    - match: compound
    - perfsonar

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

  '(?i)uxedev...?svr0[1-4]\.irtnog\.net':
    - match: pcre
    - slapd
    - mysql
    - apache
    - shibboleth.mda
    - shibboleth.sp
    - comanage.registry
    - tomcat.shibboleth-idp
    - docker
    - maven

####
#### TESTING ENVIRONMENT
####

### The testing environment is for semi-automated, semi-permanent,
### non-production system testing (e.g., performance testing,
### usability testing, stress testing, and so on).

testing:
  'I@environment:testing and G@os_family:Debian': *debian
  'I@environment:testing and G@os_family:FreeBSD': *freebsd
  'I@environment:testing and G@os_family:RedHat': *redhat
  'I@environment:testing and G@os_family:Suse': *suse
  'I@environment:testing and G@os_family:Solaris': *solaris
  'I@environment:testing and G@os_family:Windows': *windows
  'I@environment:testing and G@os_family:Windows and J@role:^(desktop|laptop)$': *windowsgui
  'I@environment:testing and G@virtual:VirtualPC': *virtualpc
  'I@environment:testing and G@virtual:VMware': *vmwareguest
  'I@environment:testing and I@role:salt-master': *saltmaster
  'I@environment:testing and I@role:mail-relay': *mailrelay
  'I@environment:testing and I@role:minecraft': *minecraft
  'I@environment:testing and I@role:identity-provider': *identityprovider
  'I@environment:testing and I@role:web-server': *webserver
  'I@environment:testing and I@role:comanage-registry': *comanageregistry
  'I@environment:testing and I@role:perfsonar': *perfsonar

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
  'I@environment:production and G@os_family:Debian': *debian
  'I@environment:production and G@os_family:FreeBSD': *freebsd
  'I@environment:production and G@os_family:RedHat': *redhat
  'I@environment:production and G@os_family:Suse': *suse
  'I@environment:production and G@os_family:Solaris': *solaris
  'I@environment:production and G@os_family:Windows': *windows
  'I@environment:production and G@os_family:Windows and J@role:^(desktop|laptop)$': *windowsgui
  'I@environment:production and G@virtual:VirtualPC': *virtualpc
  'I@environment:production and G@virtual:VMware': *vmwareguest
  'I@environment:production and I@role:salt-master': *saltmaster
  'I@environment:production and I@role:mail-relay': *mailrelay
  'I@environment:production and I@role:minecraft': *minecraft
  'I@environment:production and I@role:identity-provider': *identityprovider
  'I@environment:production and I@role:web-server': *webserver
  'I@environment:production and I@role:comanage-registry': *comanageregistry
  'I@environment:production and I@role:perfsonar': *perfsonar

  l00000006.irtnog.net:
    ## build prereqs for Synergy
    - bonjour-sdk
    - cmake

#### TOP.SLS ends here.
