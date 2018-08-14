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

# base:
#   '*':
#     []                          # no-op

####
#### PRODUCTION ENVIRONMENT
####

### The production environment reflects the current configuration of
### all user-facing services and related resources.  Should critical
### functionality or user acceptance testing of staged changes fail,
### production servers may be returned to their original configuration
### by running a highstate job.

production:
  'I@environment:production and G@os_family:Debian': &debian
{%- if salt['grains.get']('os') != 'Raspbian' %}
    - salt.pkgrepo
    - shibboleth.repo
    - salt.minion
{%- endif %}
    - augeas
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
    - htop
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
{#- Enable the ufw SLS on minions not running in AWS. #}
{%- if not salt['grains.get']('biosversion', '').endswith('amazon') %}
    - ufw
{%- endif %}
    - users
    - virt-what
    - w3m

  'I@environment:production and G@os_family:FreeBSD': &freebsd
    - poudriere.client
    - pki
    - salt.minion
    - rc
    - periodic
    - augeas
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
    - htop
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
    - users
    - w3m

  'I@environment:production and G@os_family:RedHat': &redhat
    - salt.pkgrepo
    - nux.dextop
    - nux.misc
    - scl
    - shibboleth.repo
    - salt.minion
    - hostname
    - yum
    - augeas
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
{%- if not salt['grains.get']('biosversion', '').endswith('amazon') %}
    - firewalld
{%- endif %}
    - fonts
    - git
    - htop
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
    - virt-what
    - w3m

  'I@environment:production and G@os_family:Suse': &suse
    - shibboleth.repo
    - salt.minion
    - augeas
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
    - htop
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

  'I@environment:production and G@os_family:Solaris': &solaris
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

  'I@environment:production and G@os_family:Windows': &windows
    - salt.minion
    - aws.cli
    - desktop.cleanup
    - wincert
    - merakism.agent
    - npp
    - opensc
    - p7zip
    - perfmon
    - powershell
    - putty
    - rdp
    - sysinternals-suite
    - tightvnc
    - users
    - winsnmp

  'I@environment:production and G@os_family:Windows and J@role:^(desktop|laptop)$': &windowsgui
    - adobe
    - armagetronad
    - cheat-engine
    - chrome
    - csc
    - echo-desktop
    - fiddler
    - firefox
    - fonts
    - git
    - gnupg
    - gpmc
    - icloud
    - itunes
    - rsat
    - steam
    - subversion
    - teamviewer
    - terminals
    - vlc
    - web-mgmt-tools
    - winvpn

  'I@environment:production and G@virtual:VirtualPC': &virtualpc
    - hyperv.ic

  'I@environment:production and G@virtual:VMware': &vmwareguest
    - vmware.tools

  'I@environment:production and I@role:salt-master': &saltmaster
    - salt.formulas
    - salt.gitfs.gitpython
    - salt.master
    - salt.reactors
    - salt.cloud.ext
    - saltpad
    - certbot
    - shibboleth.sp
    - apache
    - apache.certificates
    - apache.config
    - apache.mod_rewrite
    - apache.mod_shib
    - apache.mod_socache_shmcb
    - apache.mod_ssl
    - apache.mod_wsgi
    - apache.vhosts.standard
    - poudriere
    - aws.iam
    - aws.s3
    - aws.vpc
    - aws.lambda
    - salt.cloud
    - salt.ssh
    - vault

  'I@environment:production and I@role:mail-relay': &mailrelay
    - clamav.amavisd

  'I@environment:production and I@role:minecraft': &minecraft
    - spigotmc

  'I@environment:production and I@role:identity-provider': &identityprovider
    - php.ng
    - php.ng.cli
    - php.ng.ldap
    - php.ng.mbstring
    - php.ng.mysql
    - php.ng.xml
    - mysql
    - slapd
    - shibboleth.sp
    - apache
    - apache.certificates
    - apache.config
    - apache.mod_proxy
    - apache.mod_proxy_http
    - apache.mod_rewrite
    - apache.mod_shib
    - apache.mod_ssl
    - apache.vhosts.standard
    - apache.content.idp_branding
    - apache.content.md_branding
    - apache.satosa
    - comanage.registry
    - comanage.attribute-authority
    - openid-ldap
    - shibboleth.mda
    - tomcat.pwm
    - tomcat.shibboleth-idp

  'I@environment:production and I@role:web-server': &webserver
    - php.ng
    - php.ng.cli
    - php.ng.apache2
    - shibboleth.sp
    - apache
    - apache.certificates
    - apache.config
    - apache.mod_proxy
    - apache.mod_proxy_http
    - apache.mod_rewrite
    - apache.mod_shib
    - apache.mod_socache_shmcb
    - apache.mod_ssl
    - apache.mod_wsgi
    - apache.vhosts.standard
    - apache.content.testsp
    - opentracker
    - trac

  'I@environment:production and I@role:perfsonar': &perfsonar
    - perfsonar

  'I@environment:production and I@role:devstack':
    - apache
    - mysql
    - mysql.python
    - mysql.remove_test_database
    - rabbitmq
    - rabbitmq.config
    - openstack.repo
    - openstack.keystone

  'I@environment:production and I@role:moodle':
    - php.ng
    - php.ng.cli
    - php.ng.gd
    - php.ng.intl
    - php.ng.json
    - php.ng.mbstring
    - php.ng.mysqlnd
    - php.ng.xml
    - php.ng.xmlrpc
    - php.ng.zip
    - mysql
    - shibboleth.sp
    - apache
    - apache.certificates
    - apache.config
    - apache.mod_shib
    - apache.mod_ssl
    - apache.vhosts.standard
    - moodle

  'I@environment:production and I@role:sbs':
    - stunnel-sbs

  uxeprdlnxidp01.irtnog.net:
    ## dev tools
    - rpm-build

  l00000006.irtnog.net:
    ## dev tools
    - bonjour-sdk
    - blender
    - cmake
    - eclipse
    - virtualbox
    - vs-community

####
#### STAGING ENVIRONMENT
####

### The staging environment is not used for SLS module targeting;
### instead, it holds approved changes to the production environment.
### These changes may be deployed to production servers for final
### critical functionality and user acceptance testing via
### `state.apply` (with `saltenv` set to `staging`).  Only accepted
### changes may then be merged into the production environment.

# staging:
#   '*':
#     []                          # no-op

####
#### TESTING ENVIRONMENT
####

### The testing environment is not used for SLS module targeting;
### instead, it holds changes from the development environment that
### have passed functional, system, or integration testing and are
### ready to be staged for deployment in production.  Only merge
### tested changes into the staging environment after approval by the
### change advisory board (CAB).

# testing:
#   '*':
#     []                          # no-op

####
#### DEVELOPMENT ENVIRONMENT
####

### The development environment is a sandbox which requires no prior
### change authorization.  Instead, this environment is where system
### administrators must prototype any proposed changes to the
### production environment.

development:
  'I@environment:development and G@os_family:Debian': *debian
  'I@environment:development and G@os_family:FreeBSD': *freebsd
  'I@environment:development and G@os_family:RedHat': *redhat
  'I@environment:development and G@os_family:Suse': *suse
  'I@environment:development and G@os_family:Solaris': *solaris
  'I@environment:development and G@os_family:Windows': *windows
  'I@environment:development and G@os_family:Windows and J@role:^(desktop|laptop)$': *windowsgui
  'I@environment:development and G@virtual:VirtualPC': *virtualpc
  'I@environment:development and G@virtual:VMware': *vmwareguest
  'I@environment:development and I@role:salt-master': *saltmaster
  'I@environment:development and I@role:mail-relay': *mailrelay
  'I@environment:development and I@role:minecraft': *minecraft
  'I@environment:development and I@role:identity-provider': *identityprovider
  'I@environment:development and I@role:web-server': *webserver
  'I@environment:development and I@role:perfsonar': *perfsonar

#### TOP.SLS ends here.
