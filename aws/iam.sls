#### AWS/IAM.SLS --- Salt states managing AWS IAM objects

### Copyright (c) 2017, Matthew X. Economou <xenophon@irtnog.org>
###
### Permission to use, copy, modify, and/or distribute this software
### for any purpose with or without fee is hereby granted, provided
### that the above copyright notice and this permission notice appear
### in all copies.
###
### THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
### WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
### WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
### AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
### CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
### LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
### NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
### CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

### This file configures the AWS Identity and Access Management
### service, including groups, users, roles, policies, identity
### providers, encryption keys, and account settings.  The key words
### "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
### "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
### document are to be interpreted as described in RFC 2119,
### https://tools.ietf.org/html/rfc2119.  The key words "MUST (BUT WE
### KNOW YOU WON'T)", "SHOULD CONSIDER", "REALLY SHOULD NOT", "OUGHT
### TO", "WOULD PROBABLY", "MAY WISH TO", "COULD", "POSSIBLE", and
### "MIGHT" in this document are to be interpreted as described in RFC
### 6919, https://tools.ietf.org/html/rfc6919.  The keywords "DANGER",
### "WARNING", and "CAUTION" in this document are to be interpreted as
### described in OSHA 1910.145,
### https://www.osha.gov/pls/oshaweb/owadisp.show_document?p_table=standards&p_id=9794.

{%- from "aws/lib.jinja" import generate_boto_states with context %}

####
#### IAM POLICIES
####

{{ generate_boto_states('boto_iam', salt.pillar.get('aws:iam:policies', {}),
     state_id_prefix='aws_iam_policy_',
     present_function='policy_present',
     absent_function='policy_absent',
     no_op_comment='No IAM policies were specified.') }}

####
#### IAM ROLES/INSTANCE PROFILES
####

{{ generate_boto_states('boto_iam_role', salt.pillar.get('aws:iam:roles', {}),
     state_id_prefix='aws_iam_role_',
     no_op_comment='No IAM roles or instance profiles were specified.') }}

#### AWS/IAM.SLS ends here.
