## Salt's ldap3 execution module requires the python-ldap library.
## This installs Christoph Gohlke’s unofficial binary, as official
## pre-built packages of python-ldap aren't available from PyPI and
## building it locally requires Visual C++ et al.

salt-python-ldap:
  pip.installed:
    - name: https://download.lfd.uci.edu/pythonlibs/h2ufg7oq/python_ldap-3.1.0-cp27-cp27m-win_amd64.whl
    - cwd: 'C:\salt\bin\Scripts'
    - bin_env: 'C:\salt\bin\Scripts\pip.exe'
    - upgrade: True
    - reload_modules: True
