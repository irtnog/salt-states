#### AWS/IAM/INIT.SLS --- Salt states managing AWS IAM objects

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

####
#### IAM POLICIES
####

{%- for policy in salt.pillar.get('aws:iam:policies') %}
{%-   if policy.policy_document is mapping %}

aws_iam_policy_{{ policy.name }}:
  boto_iam.policy_present:
    - name: {{ policy.name }}
    - description:
        {{ policy.description|yaml_encode }}
    - policy_document:
        {{ policy.policy_document|yaml }}

{%-   else %}

aws_iam_policy_{{ policy.name }}:
  boto_iam.policy_absent:
    - name: {{ policy.name }}

{%-   endif %}

{%-   if 'region' in policy %}
    - region:
        {{ policy.region|yaml_encode }}
{%-   endif %}
{%-   if 'keyid' in policy %}
    - keyid:
        {{ policy.keyid|yaml_encode }}
{%-   endif %}
{%-   if 'key' in policy %}
    - key:
        {{ policy.key|yaml_encode }}
{%-   endif %}
{%-   if 'profile' in policy %}
    - profile:
        {{ policy.profile|yaml if policy.profile is mapping else
           salt.pillar.get(policy.profile)|yaml }}
{%-   endif %}

{%- else %}
## NB: No IAM policies were specified.
{%- endfor %}

#### AWS/IAM/INIT.SLS ends here.
