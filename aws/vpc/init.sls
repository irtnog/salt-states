{% for ... %}
{% set outer_loop = loop %}

## Create the VPC.
{% set vpc_name = ... %}
{% set vpc_net = ... %}
{% set vpc_tenancy = ... %}
{% set vpc_nsresolv = ... %}
{% set vpc_dyndns = ... %}
{% set vpc_tags = ... %}
{% set vpc_region = ... %}
aws_vpc_{{ outer_loop.index0 }}:
  boto_vpc.present:
    - name: {{ vpc_name|yaml_encode }}
    - cidr_block: {{ vpc_net|yaml_encode }}
    - instance_tenancy: {{ vpc_tenancy|yaml_encode }}
    - dns_support: {{ vpc_nsresolv|yaml_encode }}
    - dns_hostnames: {{ vpc_dyndns|yaml_encode }}
    - tags: {{ vpc_tags|yaml }}
    - region: {{ vpc_region|yaml_encode }}

## Create the VPC's subnets.
{% for ... %}
{% set subnet_name = ... %}
{% set subnet_net = ... %}
{% set subnet_az = ... %}
{% set subnet_tags = ... %}
aws_vpc_{{ outer_loop.index0 }}_subnet_{{ loop.index0 }}:
  boto_vpc.subnet_present:
    - name: {{ subnet_name|yaml_encode }}
    - cidr_block: {{ subnet_net|yaml_encode }}
    - vpc_name: {{ vpc_name|yaml_encode }}
    - availability_zone: {{ subnet_az|yaml_encode }}
    - tags: {{ subnet_tags|yaml }}
    - region: {{ vpc_region|yaml_encode }}
    - require:
        - boto_vpc: aws_vpc_{{ outer_loop.index0 }}
{% endfor %}

## Create its Internet gateways.
{% for ... %}
{% set igw_name = ... %}
{% set igw_tags = ... %}
aws_vpc_{{ outer_loop.index0 }}_internet_gateway_{{ loop.index0 }}:
  boto_vpc.internet_gateway_present:
    - name: {{ igw_name|yaml_encode }}
    - vpc_name: {{ vpc_name|yaml_encode }}
    - tags: {{ igw_tags|yaml_encode }}
    - region: {{ vpc_region|yaml_encode }}
{% endfor %}

## TODO: NAT gateways, VPC peering connections

## Create route tables and attach them to the VPC's subnets.
{% for ... %}
{% set rt_name = ... %}
{% set rt_routes = ... %}
{% set rt_subnets = ... %}
{% set rt_tags = ... %}
aws_vpc_{{ outer_loop.index0 }}_route_table_{{ loop.index0 }}:
  boto_vpc.route_table_present:
    - name: {{ rt_name|yaml_encode }}
    - vpc_name: {{ vpc_name|yaml_encode }}
    - routes: {{ rt_routes|yaml }}
    - subnet_names: {{ rt_subnets|yaml }}
    - tags: {{ rt_tags|yaml }}
    - region: {{ vpc_region|yaml }}
{% endfor %}

## Define DHCP option sets.
{% for ... %}
{% set dhcpopts_name = ... %}
{% set dhcpopts_domain = ... %}
{% set dhcpopts_resolvers = ... %}
{% set dhcpopts_ntp = ... %}
{% set dhcpopts_nbns = ... %}
{% set dhcpopts_nbnode = ... %}
{% set dhcpopts_tags = ... %}
aws_vpc_{{ outer_loop.index0 }}_dhcpopts_{{ loop.index0 }}:
  boto_vpc.dhcp_options_present:
    - name: {{ dhcpopts_name|yaml_encode }}
    - vpc_name: {{ vpc_name|yaml_encode }}
    - domain_name: {{ dhcpopts_domain|yaml_encode }}
    - domain_name_servers: {{ dhcpopts_resolvers|yaml }}
    - ntp_servers: {{ dhcpopts_ntp|yaml }}
    - netbios_name_servers: {{ dhcpopts_nbns|yaml }}
    - netbios_node_type: {{ dhcpopts_nbnode|yaml_encode }}
    - tags: {{ dhcpopts_tags|yaml }}
    - region: {{ vpc_region|yaml_encode }}
{% endfor %}

## TODO: attach a DHCP option set to the VPC.

{% endfor %}
