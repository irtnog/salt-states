{%- if grains['os_family'] in ['Debian', 'RedHat'] %}

pycharm_community:
  archive.extracted:
    - name: /opt
    - source: https://download.jetbrains.com/python/pycharm-community-2018.3.5.tar.gz
    - source_hash: https://download.jetbrains.com/python/pycharm-community-2018.3.5.tar.gz.sha256

pycharm_bash:
  file.managed:
    - name: /etc/profile.d/pycharm.sh
    - contents: |
        PATH=/opt/pycharm-community-2018.3.5/bin:${PATH}
        export PATH
    - mode: 755

pycharm_tcsh:
  file.managed:
{%-   if grains['os_family'] == 'Debian' %}
    - name: /etc/csh/login.d/pycharm.csh
{%-   else %}
    - name: /etc/profile.d/pycharm.csh
{%-   endif %}
    - contents: |
        set path = (/opt/pycharm-community-2018.3.5/bin $path)
    - mode: 755

{%- elif grains['os_family'] == 'Windows' %}

# https://download.jetbrains.com/python/pycharm-community-2018.3.5.exe
# https://download.jetbrains.com/python/pycharm-community-2018.3.5.exe.sha256
#
# pycharm-community:
#   pkg.installed:
#     []
#
# pycharm_cmd:
#   win_path.exists:
#     - name: TODO

{%- endif %}
