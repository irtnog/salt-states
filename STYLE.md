# Saltstack Style Guide

For more information about change management procedures, see TODO.
The keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in
[RFC 2119](http://www.rfc-editor.org/rfc/rfc2119.txt).  The keywords
"DANGER", "WARNING", and "CAUTION" in this document are to be
interpreted as described in
[OSHA 1910.145](https://www.osha.gov/pls/oshaweb/owadisp.show_document?p_table=standards&p_id=9794).

## State Formulas

For more information about the recommended format of Salt state
formulas, refer to the
[Writing Formulas](http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas)
section of the
[Salt Conventions](http://docs.saltstack.com/en/latest/topics/development/conventions/index.html)
documentation.

## Comments

### YAML

We recommend these conventions for comments in YAML files (i.e., files
ending in `.yaml` or `.sls`).

**Single Number Sign**

Comments that start with a single number sign, `#`, should all be
aligned to the same column on the right of the YAML file.  Such
comments explain the meaning of the marked line of code or data and
may not form complete sentences.  For example:

```yaml
development:
  'I@environment:development and G@os_family:RedHat':
    - match: compound
    - epel
    - nux.dextop                # requires EPEL
    - nux.misc
```

**Double Number Sign**

Comments that start with two number signs, `##`, should be aligned to
the same level of indentation as the code or data at that point in the
YAML file.  Such comments usually describe the purpose of the
following lines or the condition of a system or service at that point
and may be complete sentences.  For example:

```yaml
base:
  '*':
    - defaults

  ## Make role assignments based on the hostname 'role' field.
  '*mx??.example.com':
    - role.mail-relay
  '*lnxvirt??.example.com':
    - role.openstack            # Linux-only
  '*salt??.example.com':
    - role.salt-master
```

**Triple and Quadruple Number Sign**

Comments that start with three number signs, `###`, should start at
the left margin.  We use them for comments between top-level YAML
elements within a section, which are always full sentences.  Comments
that start with four number signs, `####`, should be aligned to the
left margin and are used for headings of major sections of a program.
For example:

```yaml
####
#### BASE ENVIRONMENT
####

### Currently, the base environment is not used except for targeting
### (i.e., this file).  This environment corresponds with the master
### branch of this repository.

base:
  '*':
    []                          # no-op
```
