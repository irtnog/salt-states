# IRTNOG Salt Style Guide

This document describes rules and guidelines for how state formulas,
comments, and commit messages are formatted.  This leads to more
readable code/messages that are easier to follow when reading formulas
or looking through the project history.  For more information about
change management procedures, see TODO.  The keywords "MUST", "MUST
NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in
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

(This has been adapted in part from the
[GNU Emacs Lisp Reference Manual, Section D.7 ("Tips on Writing Comments")](https://www.gnu.org/software/emacs/manual/html_node/elisp/Comment-Tips.html#Comment-Tips).)

### "FIXME", "TODO", and Other Comment Annotations

TODO

### YAML

Comments in YAML files (i.e., files ending in `.yaml` or `.sls`)
should take the following forms.

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

## Git Commit Messages

(This has been adapted from
[Contributing to AngularJS](https://github.com/angular/angular.js/blob/master/CONTRIBUTING.md#commit)
and the
[AngularJS Git Commit Message Conventions](https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit#).)

### Commit Message Format

Each commit message must consist of a header, a body, and a footer.
The header must follow a special format that includes a type, an
optional scope, and a subject:

```
<type>(<scope>): <subject>

<body>

<footer>
```

Any line must not be longer than 70 characters.  This makes the commit
message easier to read on GitHub and in various git tools.

### Type

The commit's type should be one of the following:

  - **feat**: a new feature

  - **fix**: a bug fix or other correction

  - **docs**: documentation-only changes

  - **style**: changes that do not affect the meeting of the code
    (e.g., whitespace, formatting, missing syntax elements, etc.)

  - **refactor**: changes that neither fix bugs nor add features

  - **perf**: changes that improve performance

  - **test**: adding missing tests

  - **chore**: changes to the build process or auxiliary tools and
  libraries such as document generation

### Scope

The commit's scope may be anything specifying the place of the commit
change, e.g., an SLS module name like "kerberos5" or "poudriere", an
environment name like "testing", a role name like "salt-master" or
"mail-relay".

### Subject

The subject must contain a short, one-line description of the change.
It must start with a verb in the imperative, present tense ("change",
not "changes" nor "changed").  It must all be in lower case except for
proper nouns, and it must not have sentence-ending punctuation at the
end (such as a period or exclamation mark).

### Body

The body should provide a meaningful commit message, which like the
subject must use the imperative, present tense, as if giving orders.
The message should include the motivations for the change and contrast
its implementation with previous behavior.  Make sure the explanation
can be understood without external resources (e.g., don't just link to
a change request ticket, but also summarize the relevant points of the
request's discussion or commentary).

### Footer

Closed service incident or problem reports should be listed with each
on a separate line in the footer, prefixed with the "Closes" keyword.
For example:

```
Closes #234
Closes https://helpdesk.example.com/zentrack/ticket.php?id=65535
```
