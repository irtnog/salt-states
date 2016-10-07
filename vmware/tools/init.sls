{% from "vmware/tools/map.jinja" import vmware_tools_settings with context %}

vmware_tools:
  pkg.installed:
    - pkgs: {{ vmware_tools_settings.packages|yaml }}

  file.recurse:
    - name: {{ vmware_tools_settings.confdir|yaml_encode }}
    - source: salt://vmware/tools/files/
    - template: jinja
    - include_empty: yes
    - exclude_pat: .gitignore
    - user: root
    - group: 0
    - dir_mode: 755
    - file_mode: 755
    - require:
        - pkg: vmware_tools

  service.running:
    - names: {{ vmware_tools_settings.services|yaml }}
    - enable: True
    - watch:
        - pkg: vmware_tools
        - file: vmware_tools

{% if vmware_tools_settings.post_thaw_script != [] %}
vmware_tools_post_thaw_script:
  file.managed:
    - name: {{ '%spost-thaw-script%s'|format(
                 vmware_tools_settings.hookdir,
                 vmware_tools_settings.hooksuffix
               )|yaml_encode }}
    - source: salt://vmware/tools/hooks/post-thaw-script
    - template: jinja
    - user: root
    - group: 0
    - mode: 755
    - require:
        - pkg: vmware-tools
{% endif %}

{% if vmware_tools_settings.pre_freeze_script != [] %}
vmware_tools_pre_freeze_script:
  file.managed:
    - name: {{ '%spre-freeze-script%s'|format(
                 vmware_tools_settings.hookdir,
                 vmware_tools_settings.hooksuffix
               )|yaml_encode }}
    - source: salt://vmware/tools/hooks/pre-freeze-script
    - template: jinja
    - user: root
    - group: 0
    - mode: 755
    - require:
        - pkg: vmware_tools
{% endif %}

{% if grains['os_family'] == 'FreeBSD' %}
vmware_tools_kmod_vmmemctl:
  sysrc.managed:
    - name: vmware_guest_vmmemctl_enable
    - value: "YES"
    - require:
        - pkg: vmware_tools
        - file: vmware_tools
    - watch_in:
        - service: vmware_tools

vmware_tools_kmod_vmxnet:
  sysrc.managed:
    - name: vmware_guest_vmxnet_enable
    - value: "YES"
    - require:
        - pkg: vmware_tools
        - file: vmware_tools
    - watch_in:
        - service: vmware_tools

vmware_tools_kmod_vmblock:
  sysrc.managed:
    - name: vmware_guest_vmblock_enable
    - value: "YES"
    - require:
        - pkg: vmware_tools
        - file: vmware_tools
    - watch_in:
        - service: vmware_tools

vmware_tools_kmod_vmhgfs:
  sysrc.managed:
    - name: vmware_guest_vmhgfs_enable
    - value: "YES"
    - require:
        - pkg: vmware_tools
        - file: vmware_tools
    - watch_in:
        - service: vmware_tools
{% endif %}
