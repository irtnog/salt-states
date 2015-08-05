#### _MODULES/IRTNOG.PY --- Convenience library

### Unfortunately, several useful functions aren't accessible from
### Jinja, whether natively or via __salt__.  This module provides a
### wrapper for those functions we need to selectively import, like
### salt.utils.dictupdate.update().

import salt.utils.dictupdate

def __virtual__():
    return 'irtnog'

def dictupdate(dest, upd):
    '''Recursively merge dictionaries

    Contrast with Python\'s dict.update() method, which only performs
    a shallow merge.
    '''
    return salt.utils.dictupdate.update(dest, upd)

#### _MODULES/IRTNOG.PY ends here.
