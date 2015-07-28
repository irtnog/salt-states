{% from "hyperv/map.jinja" import hyperv_settings with context %}

hyperv:
  pkg.installed:
    - pkgs: {{ hyperv_settings.packages|yaml }}

{% if grains['os_family'] == 'RedHat' %}
## The Hyper-V Synthetic Video Frame Buffer driver (hyperv_fb)
## defaults to a screen resolution 1152x864 on Linux.  This change
## lowers it to 640x480, which better suits a text-only server
## console.
hyperv_fb_modprobe_conf:
  file.managed:
    - name: /etc/modprobe.d/hyperv_fb.conf
    - user: root
    - group: 0
    - mode: 444
    - source: salt://hyperv/files/hyperv_fb.conf
    - require:
      - pkg: hyperv

## The Hyper-V Dynamic Memory feature requres additional configuration
## on CentOS and Red Hat Enterprise Linux in order to enable Hot-Add
## support (http://technet.microsoft.com/en-us/library/dn531026.aspx).
hyperv_memory_udev_balloon_rules:
  file.managed:
    - name: /etc/udev/rules.d/100-balloon.rules
    - user: root
    - group: 0
    - mode: 444
    - source: salt://hyperv/files/100-balloon.rules
    - require:
      - pkg: hyperv
{% endif %}
