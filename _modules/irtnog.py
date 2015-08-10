#### _MODULES/IRTNOG.PY --- Convenience library

### Unfortunately, several useful functions aren't accessible from
### Jinja, whether natively or via __salt__.  This module provides a
### wrapper for those functions we need to selectively import, like
### salt.utils.dictupdate.update().

from salt.utils.dictupdate import update as dictupdate

def __virtual__():
    return 'irtnog'

#### _MODULES/IRTNOG.PY ends here.
