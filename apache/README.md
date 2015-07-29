# apache

This Salt formula installs and configures the Apache HTTP server with
ModSecurity and mod_ssl enabled by default.  Web sites configured by
this formula may optionally enable HTTPS using encryption settings
based on the Mozilla Operations Security team's
[best current practices](https://wiki.mozilla.org/Security/Server_Side_TLS).
Configuration data such as web site names, X.509 certificates and
private keys, and active WAF rulesets comes from (or can be overrided
in) Pillar, while web site content (whether on the file system or
inside a database) must be managed separately.  The formula currently
suppports the Debian, FreeBSD, and Red Hat operating system families.
The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in
[RFC 2119](http://www.rfc-editor.org/rfc/rfc2119.txt).  The keywords
"DANGER", "WARNING", and "CAUTION" in this document are to be
interpreted as described in
[OSHA 1910.145](https://www.osha.gov/pls/oshaweb/owadisp.show_document?p_table=standards&p_id=9794).

## Implementation Notes

Because this formula targets non-Unix operating systems, formula
developers or end users must not embed directory separators in state
formulas.  Instead, when specifying directory names via
*defaults.yaml*, *map.jinja*, or Pillar, they must always include the
trailing directory separator, e.g., `/var/lib/httpd/`, `C:\Program
Files\httpd`.

TODO: supplement/supplant default configs instead of altering them

## Bugs

This formula does not currently handle any firewall configuration
changes needed to allow external access to the web server.  On
platforms with a default-deny firewall policy (e.g., Red Hat
Enterprise Linux), one will need to create suitable policy exceptions
separately.

When using name-based virtual hosts, the default web site should
return a HTTP 403 to avoid leaking information about the server
configuration.

## Available State Modules

*   `apache`

    Installs (or updates) the web server and related packages (if
    any); and configures the web server, modules, and web sites based
    on settings in Pillar.

*   `apache.owasp_modsecurity_crs`

	Downloads and installs the latest version of the
    [Open Web Application Security Project](https://www.owasp.org/)
    [ModSecurity Core Rule Set](https://github.com/SpiderLabs/owasp-modsecurity-crs).
    This requires Git.

## Pillar Data

TODO
