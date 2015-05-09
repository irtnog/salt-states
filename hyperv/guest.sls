{% from "hyperv/map.jinja" import hyperv with context %}
{% if hyperv %}

{% if hyperv.packages %}
hyperv:
  pkg:
    - installed
    - pkgs:
      {% for package in hyperv.packages %}
      - {{ package }}
      {% endfor %}
    - require:
      - module: update_repos
{% endif %}

## FIXME: what about services to install, configure, and start?

{% if grains['os_family'] == 'RedHat' %}
###
### RED HAT FAMILY-SPECIFIC
###

## The Hyper-V Synthetic Video Frame Buffer driver (hyperv_fb)
## defaults to a screen resolution 1152x864 on Linux.  This change
## lowers it to 640x480, which better suits a text-only server
## console.

hyperv_fb_modprobe_conf:
  file:
    - managed
    - name: /etc/modprobe.d/hyperv_fb.conf
    - user: root
    - group: 0
    - mode: 444
    - source: salt://hyperv/files/hyperv_fb.conf

## The Hyper-V Dynamic Memory feature requres additional configuration
## on CentOS and Red Hat Enterprise Linux in order to enable Hot-Add
## support (http://technet.microsoft.com/en-us/library/dn531026.aspx).

hyperv_memory_udev_balloon_rules:
  file:
    - managed
    - name: /etc/udev/rules.d/100-balloon.rules
    - user: root
    - group: 0
    - mode: 444
    - source: salt://hyperv/files/100-balloon.rules
{% endif %}

{% endif %}
