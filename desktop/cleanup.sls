remove_allusers_desktop_shortcuts:
  file.absent:
    - names:
        {{ salt['file.find'](
             salt['environ.get']('PUBLIC') ~ '\\Desktop',
             name='*.lnk'
           )|yaml }}
    - order: last
