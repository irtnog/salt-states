{%- set workdir = salt['pillar.get']('portsnap:workdir', None) %}
portsnap_workdir:
{%- if workdir %}
  sysrc.managed:
    - value: {{ workdir|yaml_encode }}
{%- else %}
  sysrc.absent:
{%- endif %}
    - name: WORKDIR
    - file: /etc/portsnap.conf

{%- set portsdir = salt['pillar.get']('portsnap:portsdir', None) %}
portsnap_portsdir:
{%- if portsdir %}
  sysrc.managed:
    - value: {{ portsdir|yaml_encode }}
{%- else %}
  sysrc.absent:
{%- endif %}
    - name: PORTSDIR
    - file: /etc/portsnap.conf

{%- set servername = salt['pillar.get']('portsnap:servername', 'portsnap.FreeBSD.org') %}
portsnap_servername:
  sysrc.managed:
    - value: {{ servername|yaml_encode }}
    - name: SERVERNAME
    - file: /etc/portsnap.conf

{%- set keyprint = salt['pillar.get']('portsnap:keyprint', '9b5feee6d69f170e3dd0a2c8e469ddbd64f13f978f2f3aede40c98633216c330') %}
portsnap_keyprint:
  sysrc.managed:
    - value: {{ keyprint|yaml_encode }}
    - name: KEYPRINT
    - file: /etc/portsnap.conf
