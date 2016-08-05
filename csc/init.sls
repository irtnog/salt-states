## From [Files that you add to the Offline Files folder on a Windows
## XP-based computer are synchronized when another person uses the
## computer](https://support.microsoft.com/en-us/kb/811660), enable
## forced silent auto reconnection.
##
## When a server has been unavailable (offline mode) and then becomes
## available again for connection, Offline Files Client Side Caching
## tries to transition that server to online mode if all the following
## conditions are true:
##
## - There are no offline changes for that server on the local
##   computer.
## - There are no open file handles for that server on the local
##   computer.
## - The server is accessed over a "fast" link.  You can adjust the
##   definition of "slow" and "fast" by using the SlowLinkSpeed
##   Offline Files policy.
##
## This configures Offline Files Client Side Caching to ignore these
## conditions and transition the server to online mode regardless of
## whether these conditions exist.
##
## Note that after making this change, the following behavior may occur:
##
## - Any offline changes will remain unsynchronized and unavailable
##   until the changes are synchronized in the future.  This situation
##   causes a dirty cache condition that is announced through a small
##   warning overlay image on the Offline Files icon in the
##   notification area.
##
## - Any open handles to files that are cached on the associated
##   server will be automatically closed and invalidated.  This action
##   may cause problems if the programs that are using those files
##   cannot work gracefully with invalid file handles.
##
## - If the server is available over a slow network link, such as a
##   satellite link or a telephone line, the server will still be
##   transitioned online.  This scenario may cause very slow access to
##   the remote file system on the server from the local computer.
##
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\NetCache\SilentForcedAutoReconnect:
  reg.present:
    - vtype: REG_DWORD
    - value: 1
