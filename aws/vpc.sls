#### AWS/VPC.SLS --- Salt states managing virtual networks in AWS

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

### This file configures the AWS Virtual Private Cloud service,
### including subnets, Internet and NAT gateways, peering connections,
### route tables, DHCP options, and security groups.  The key words
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

{%- for k, v in salt['pillar.get']('aws:vpc', {})|dictsort %}
{%-   set outer_loop   = loop %}
{%-   set vpc_name     = k %}
{%-   set vpc_net      = v['network'] %}
{%-   set vpc_tenancy  = v['tenancy']|default('default') %}
{%-   set vpc_nsresolv = v['dns_resolution']|default(True) %}
{%-   set vpc_dyndns   = v['dns_hostnames']|default(True) %}
{%-   set vpc_tags     = v['tags']|default([]) %}
{%-   set vpc_region   = v['region']|default('us-east-1') %}

####
#### VPC {{ vpc_name|upper }} IN {{ vpc_region|upper }}
####

aws_vpc_{{ outer_loop.index0 }}:
  boto_vpc.present:
    - name:
        {{ vpc_name|yaml_encode }}
    - cidr_block:
        {{ vpc_net|yaml_encode }}
    - instance_tenancy:
        {{ vpc_tenancy|yaml_encode }}
    - dns_support:
        {{ vpc_nsresolv|yaml_encode }}
    - dns_hostnames:
        {{ vpc_dyndns|yaml_encode }}
    - tags:
        {{ vpc_tags|yaml }}
    - region:
        {{ vpc_region|yaml_encode }}

### Define any DHCP option sets (mimic Amazon's by default).

{%-   for dopt in v['dhcp_option_sets']|default([{
        'name': vpc_name,
      }]) %}
{%-     set dopt_name      = dopt['name'] %}
{%-     set dopt_domain    = dopt['domain']|default(
          'ec2.internal' if vpc_region == 'us-east-1' else
          vpc_region ~ '.compute.internal'
        ) %}
{%-     set dopt_resolvers = dopt['dns_servers']|default('AmazonProvidedDNS') %}
{%-     set dopt_ntp       = dopt['ntp_servers']|default(None) %}
{%-     set dopt_nbns      = dopt['wins_servers']|default(None) %}
{%-     set dopt_nodetype  = dopt['netbios_node_type']|default(None) %}
{%-     set dopt_tags      = dopt['tags']|default(vpc_tags) %}

aws_vpc_{{ outer_loop.index0 }}_dopt_{{ loop.index0 }}:
  boto_vpc.dhcp_options_present:
    - name:
        {{ dopt_name|yaml_encode }}
    - vpc_name:
        {{ vpc_name|yaml_encode }}
    - domain_name:
        {{ dopt_domain|yaml_encode }}
    - domain_name_servers:
        {{ dopt_resolvers|yaml_encode if dopt_resolvers is string else
           dopt_resolvers|yaml }}
    - ntp_servers:
        {{ dopt_ntp|yaml }}
    - netbios_name_servers:
        {{ dopt_nbns|yaml }}
    - netbios_node_type:
        {{ dopt_nodetype|yaml_encode }}
    - tags:
        {{ dopt_tags|yaml }}
    - region:
        {{ vpc_region|yaml_encode }}
    - require:
        - boto_vpc: aws_vpc_{{ outer_loop.index0 }}

{%-   endfor %}

### Create the VPC's subnets.

{%-   set subnets = [] %}
{%-   for subnet in v['subnets'] %}{#- TODO: sensible defaults #}
{%-     set subnet_name = subnet['name'] %}
{%-     set subnet_net  = subnet['cidr'] %}
{%-     set subnet_az   = subnet['availability_zone'] %}
{%-     set subnet_tags = subnet['tags']|default(vpc_tags) %}

aws_vpc_{{ outer_loop.index0 }}_subnet_{{ loop.index0 }}:
  boto_vpc.subnet_present:
    - name:
        {{ subnet_name|yaml_encode }}
    - cidr_block:
        {{ subnet_net|yaml_encode }}
    - vpc_name:
        {{ vpc_name|yaml_encode }}
    - availability_zone:
        {{ subnet_az|yaml_encode }}
    - tags:
        {{ subnet_tags|yaml }}
    - region:
        {{ vpc_region|yaml_encode }}
    - require:
        - boto_vpc: aws_vpc_{{ outer_loop.index0 }}

{%-     do subnets.append(subnet_name) %}
{%-   endfor %}

### Create the VPC's Internet gateways (usually just one).

{%-   for igw in v['internet_gateways']|default([{
        'name': vpc_name,
      }]) %}
{%-     set igw_name = igw['name'] %}
{%-     set igw_tags = igw['tags']|default(vpc_tags) %}

aws_vpc_{{ outer_loop.index0 }}_internet_gateway_{{ loop.index0 }}:
  boto_vpc.internet_gateway_present:
    - name:
        {{ igw_name|yaml_encode }}
    - vpc_name:
        {{ vpc_name|yaml_encode }}
    - tags:
        {{ igw_tags|yaml }}
    - region:
        {{ vpc_region|yaml_encode }}
    - require:
        - boto_vpc: aws_vpc_{{ outer_loop.index0 }}

{%-   endfor %}

### Create the VPC's NAT gateways (again, usually just one).

{%-   for natgw in v['nat_gateways']|default([]) %}{#- TODO: sensible defaults #}
{%-     set natgw_name     = natgw['name'] %}
{%-     set natgw_subnet   = natgw['subnet'] %}
{%-     set natgw_eipalloc = natgw['eipalloc']|default(None) %}

aws_vpc_{{ outer_loop.index0 }}_nat_gateway_{{ loop.index0 }}:
  boto_vpc.nat_gateway_present:
    - name:
        {{ natgw_name|yaml_encode }}
    - subnet_name:
        {{ natgw_subnet|yaml_encode }}
{%-     if natgw_eipalloc %}
    - allocation_id:
        {{ natgw_eipalloc|yaml_encode }}
{%-     endif %}
    - region:
        {{ vpc_region|yaml_encode }}
    - require:
{%-     for subnet in v['subnets'] %}
        - boto_vpc: aws_vpc_{{ outer_loop.index0 }}_subnet_{{ loop.index0 }}
{%-     endfor %}

{%-   endfor %}

### TODO: request/accept VPC peering connections

### Create route tables and attach them to the VPC's subnets.

{%-   for rt in v['route_tables']|default([{
        'name': vpc_name,
        'routes': [{
          'destination_cidr_block': '0.0.0.0/0',
          'internet_gateway_name':  vpc_name,
        }],
        'subnets': subnets,
      }]) %}
{%-     set rt_name    = rt['name'] %}
{%-     set rt_routes  = rt['routes'] %}
{%-     set rt_subnets = rt['subnets'] %}
{%-     set rt_tags    = rt['tags']|default(vpc_tags) %}

aws_vpc_{{ outer_loop.index0 }}_route_table_{{ loop.index0 }}:
  boto_vpc.route_table_present:
    - name:
        {{ rt_name|yaml_encode }}
    - vpc_name:
        {{ vpc_name|yaml_encode }}
    - routes:
        {{ rt_routes|yaml }}
    - subnet_names:
        {{ rt_subnets|yaml }}
    - tags:
        {{ rt_tags|yaml }}
    - region:
        {{ vpc_region|yaml }}
    - require:
{%-     for subnet in v['subnets'] %}
        - boto_vpc: aws_vpc_{{ outer_loop.index0 }}_subnet_{{ loop.index0 }}
{%-     endfor %}
{%-     for igw in v['internet_gateways']|default([{
            'name': vpc_name ~ '-Internet-Gateway',
        }]) %}
        - boto_vpc: aws_vpc_{{ outer_loop.index0 }}_internet_gateway_{{ loop.index0 }}
{%-     endfor %}
{%-     for natgw in v['nat_gateways']|default([]) %}
        - boto_vpc: aws_vpc_{{ outer_loop.index0 }}_nat_gateway_{{ loop.index0 }}
{%-     endfor %}

{%-   endfor %}

### TODO: security groups

{%- endfor %}

#### AWS/VPC.SLS ends here.
