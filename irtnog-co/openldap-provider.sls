{%- set username = salt['pillar.get']('irtnog_co:ldap_admin:username') %}
{%- set password = salt['pillar.get']('irtnog_co:ldap_admin:password') %}
{%- set pwhash = salt['pillar.get']('irtnog_co:ldap_admin:password_hash') %}

openldap_provider:
  pkg.installed:
    - pkgs:
        - openldap-clients
        - openldap-servers
        - python-ldap

  service.running:
    - name: slapd
    - enable: True
    - watch:
        - pkg: openldap_provider

  file.directory:
    - name: /var/lib/ldap/irtnog
    - user: ldap
    - group: ldap
    - dir_mode: 700
    - require:
        - pkg: openldap_provider

  ldap.managed:
    - name: ldapi:///
    - connect_spec:
        bind:
          method: sasl
    - entries:
        - 'olcDatabase={1}monitor,cn=config':
            - replace:
                olcAccess:
                  - {{ [ '{0}to *',
                         'by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" read',
                         'by dn.base="cn=%s,o=IRTNOG" read'|format(username),
                         'by * none',
                       ]|join(' ')|yaml_encode }}
        - 'olcDatabase={3}mdb,cn=config':
            - add:
                objectClass:
                  - olcDatabaseConfig
                  - olcMdbConfig
                olcDatabase:
                  '{3}mdb'
                olcDbDirectory:
                  /var/lib/ldap/irtnog
                olcDbIndex:
                  - objectClass eq,pres
                  - ou,cn,mail,surname,givenname eq,pres,sub
                olcSuffix:
                  o=IRTNOG
                olcRootDN:
                  {{ 'cn=%s,o=IRTNOG'|format(username)|yaml_encode }}
                olcRootPW:
                  {{ pwhash|yaml_encode }}
                olcAccess:
                  - {{ [ '{0}to attrs=userPassword,shadowLastChange',
                         'by dn="cn=%s,o=IRTNOG" write'|format(username),
                         'by anonymous auth',
                         'by self write',
                         'by * none'
                       ]|join(' ')|yaml_encode }}
                  - {{ [ '{1}to dn.base=""',
                         'by * read',
                       ]|join(' ')|yaml_encode }}
                  - {{ [ '{2}to *',
                         'by dn="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" write',
                         'by dn="cn=%s,o=IRTNOG" write'|format(username),
                         'by * read',
                       ]|join(' ')|yaml_encode }}
    - require:
        - service: openldap_provider
        - file: openldap_provider

openldap_provider_irtnog:
  ldap.managed:
    - name: ldapi:///
    - connect_spec:
        bind:
          method: simple
          dn: {{ 'cn=%s,o=IRTNOG'|format(username)|yaml_encode }}
          password: {{ password|yaml_encode }}
    - entries:
        - o=IRTNOG:
            - add:
                objectClass:
                  - top
                  - organization
                o:
                  IRTNOG
        - {{ 'cn=%s,o=IRTNOG'|format(username)|yaml_encode }}:
            - add:
                objectClass:
                  - organizationalRole
                cn:
                  {{ username|yaml_encode }}
        - ou=People,o=IRTNOG:
            - add:
                objectClass:
                  - organizationalUnit
                ou:
                  People
        - ou=Groups,o=IRTNOG:
            - add:
                objectClass:
                  - organizationalUnit
                ou:
                  Groups
    - require:
        - ldap: openldap_provider
