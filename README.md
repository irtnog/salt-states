# IRTNOG Salt States

This repository contains service package definitions in the form of
Salt states (SLS).  Each top-level directory describes a single
resource or service, such as `kerberos5` or `poudriere`.  One or more
of these resources/services define a service package, such as
`salt-master` or `mail-relay`.  The repository currently consists of
the following branches:

- *master*, corresponding to the Salt **base** environment (unused
  except for state targeting);

- *development*, a sandbox;

- *testing*, for semi-automated non-production functional,
  performance, or quality assurance testing;

- *staging*, for pre-production user acceptance testing; and

- *production*, managing the configuration of online user-facing
  services and related resources.

Secrets such as passwords or private keys, configuration details such
as hostnames or IP addresses, and targeting data such as environment
or role assignments are not stored here.  Instead, that data is stored
in Salt Pillar.  For an example of how we structure this private
Pillar data, refer to the
[irtnog/salt-pillar-example repository on GitHub](https://github.com/irtnog/salt-pillar-example).

## Targeting

TODO

## Authoring

TODO
