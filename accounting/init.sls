{% from "accounting/map.jinja" import accounting_settings with context %}

accounting:
  pkg.installed:
    - pkgs: {{ accounting_settings.packages|yaml }}
  service.running:
    - name: {{ accounting_settings.service}}
    - enable: True
    - watch:
        - pkg: accounting

{% if grains.os_family == 'FreeBSD' %}
periodic_conf_accounting_settings:
  file.accumulated:
    - name: periodic_conf_accumulator
    - filename: /etc/periodic.conf
    - text: 'daily_accounting_compress="YES"'
    - require:
        - service: accounting
    - require_in:
        - file: periodic_conf

{% elif grains.os_family == 'Solaris' %}
flow_accounting:
  cmd.run:
    - name: acctadm -e extended -f /var/adm/exact/flow flow
    - onlyif: acctadm | grep "Flow accounting: inactive"
  service.runing:
    - name: svc:/system/extended-accounting:flow
    - enable: True
    - require:
        - cmd: flow_accounting

net_accounting:
  cmd.run:
    - name: acctadm -e extended -f /var/adm/exacct/net network
    - onlyif: acctadm | grep "Net accounting: inactive"
  service.running:
    - name: svc:/system/extended-accounting:net
    - enable: True
    - require:
        - cmd: net_accounting

process_accounting:
  cmd.run:
    - name: acctadm -e extended -f /var/adm/exacct/proc process
    - onlyif: acctadm | grep "Process accounting: inactive"
    - require_in:
        - service: accounting

task_accounting:
  cmd.run:
    - name: acctadm -e extended -f /var/adm/exacct/task task
    - onlyif: acctadm | grep "Task accounting: inactive"
  service.running:
    - name: svc:/system/extended-accounting:task
    - enable: True
    - require:
        - cmd: task_accounting
{% endif %}