#### PYTHON-LDAP/INIT.SLS --- Install and configure the python-ldap library

### Salt's ldap3 execution module requires the python-ldap library.

{%- set os_family = salt['grains.get']('os_family') %}
{%- if os_family == 'Windows' %}

## This installs Christoph Gohlke’s unofficial binary as official
## pre-built packages of python-ldap are not available from PyPI, and
## building it locally requires Visual C++ et al.
python-ldap:
  pip.installed:
    - name: https://download.lfd.uci.edu/pythonlibs/h2ufg7oq/python_ldap-3.1.0-cp27-cp27m-win_amd64.whl
    - cwd: 'C:\salt\bin\Scripts'
    - bin_env: 'C:\salt\bin\Scripts\pip.exe'
    - upgrade: True
    - reload_modules: True

{%- endif %}

#### PYTHON-LDAP/INIT.SLS ends here.
