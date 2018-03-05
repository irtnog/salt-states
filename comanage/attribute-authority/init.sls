## This assumes that the OpenLDAP server (slapd) is already installed
## and running on this minion, and that no conflicting database are
## configured.

{%- set provisioner_monitor_acls = [] %}
{%- for co, settings in collaborative_organizations|dictsort %}
{%-   set db_create_state_id = 'comanage_co_ldap_db_%s'|format(co|lower) %}
{%-   set o_create_state_id = 'comanage_co_ldap_org_%s'|format(co|lower) %}
{%-   set co_id = settings['co_id'] %}
{%-   set username = settings['username'] %}
{%-   set password = settings['password'] %}
{%-   set pwhash = settings['pwhash'] %}
{%-   do provisioner_monitor_acls.append('by dn.base="cn=%s,o=%s" read'|format(username, co)) %}

## Create a memory database (MDB) for the {{ co }} CO.
{{ db_create_state_id|yaml_encode }}:
  file.directory:
    - name:
        {{ '/var/lib/ldap/%s'|format(co|lower)|yaml_encode }}
    - user: ldap
    - group: ldap
    - dir_mode: 700

  ldap.managed:
    - name: ldapi:///
    - connect_spec:
        bind:
          method: sasl
    - entries:
        - 'olcDatabase={}mdb,cn=config':
            - add:
                objectClass:
                  [olcDatabaseConfig, olcMdbConfig]
                olcDatabase:
                  {{ '{%s}mdb'|format(co_id)|yaml_encode }}
                olcDbDirectory:
                  {{ '/var/lib/ldap/%s'|format(co|lower)|yaml_encode }}
                olcDbIndex:
                  - objectClass eq,pres
                  - ou,cn,mail,surname,givenname eq,pres,sub
                olcSuffix:
                  {{ 'o=%s'|format(co)|yaml_encode }}
                olcRootDN:
                  {{ 'cn=%s,o=%s'|format(username, co)|yaml_encode }}
                olcRootPW:
                  {{ pwhash|yaml_encode }}
                olcAccess:
                  - {{ [ '{0}to attrs=userPassword,shadowLastChange'
                       , 'by dn="cn=%s,o=%s" write'|format(username, co)
                       , 'by anonymous auth'
                       , 'by self write'
                       , 'by * none'
                       ]|join(' ')|yaml_encode }}
                  - {{ [ '{1}to dn.base=""'
                       , 'by * read'
                       ]|join(' ')|yaml_encode }}
                  - {{ [ '{2}to *'
                       , 'by dn="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" write'
                       , 'by dn="cn=%s,o=%s" write'|format(username, co)
                       , 'by * read'
                       ]|join(' ')|yaml_encode }}
    - require:
        - ldap: comanage_co_ldap_provisioner_monitor_acl
        - file: {{ db_create_state_id|yaml_encode }}

{{ o_create_state_id|yaml_encode }}:
  ldap.managed:
    - name: ldapi:///
    - connect_spec:
        bind:
          method: simple
          dn:
            {{ 'cn=%s,o=%s'|format(username, co)|yaml_encode }}
          password:
            {{ password|yaml_encode }}
    - entries:
        ## create the organization root
        - {{ 'o=%s'|format(co)|yaml_encode }}:
            - add:
                objectClass: [top, organization]
                o: {{ co|yaml_encode }}
        ## create the admin account at the root
        - {{ 'cn=%s,o=%s'|format(username, co)|yaml_encode }}:
            - add:
                objectClass: [organizationRole]
                cn: {{ username|yaml_encode }}
{%-   for ou in ['People', 'Groups'] %}
        ## create the {{ ou }} OU (provisioned by COmanage)
        - {{ 'ou=%s,o=%s'|format(ou, co)|yaml_encode }}:
            - add:
                objectClass: [organizationalUnit]
                ou: {{ ou|yaml_encode }}
{%-   endfor %}
    - require:
        - ldap: {{ db_create_state_id|yaml_encode }}

{%- endfor %}

{#- FIXME: may not be necessary
comanage_co_ldap_provisioner_monitor_acl:
  ldap.managed:
    - name: ldapi:///
    - connect_spec:
        bind:
          method: sasl
    - entries:
        - 'olcDatabase={1}monitor,cn=config':
            - replace:
                olcAccess:
                  - {{ [ '{0} to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" read'
                       , provisioner_monitor_acls|join(' ')
                       , 'by * none'
                       ]|join(' ')|yaml_encode }}
#}
