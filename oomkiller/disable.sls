oomkiller_disable:
  sysctl.present:
    - name:
        vm.overcommit_memory
    - value:
        2
