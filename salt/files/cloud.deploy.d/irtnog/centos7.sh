#!/bin/sh
{% set cloud = salt['pillar.get']('salt:cloud', {}) -%}

## pre-requisites
yum -y update >/dev/null 2>&1
yum -y install epel-release >/dev/null 2>&1
yum -y install python-pip >/dev/null 2>&1
pip install --upgrade awscli >/dev/null 2>&1
{% if 'irtnog_ec2_whoami_key' in cloud -%}
AWS_ACCESS_KEY_ID={{ cloud.get('irtnog_ec2_whoami_key')|yaml_dquote }}
AWS_SECRET_ACCESS_KEY={{ cloud.get('irtnog_ec2_whoami_secret')|yaml_dquote }}
export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
{%- endif %}

## determine name from instance tags
INSTANCE_ID=$(curl --silent http://instance-data/latest/meta-data/instance-id)
REGION=$(curl --silent http://instance-data/latest/meta-data/placement/availability-zone | sed -e 's/.$//')
FQDN=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" --region $REGION --output=text | cut -f5)
HOSTNAME=$(echo ${FQDN} | sed 's/\..*//')

## set the hostname
echo ${FQDN} > /etc/hostname
hostnamectl set-hostname ${FQDN} >/dev/null 2>&1
systemctl restart systemd-hostnamed >/dev/null 2>&1
echo hostname: ${HOSTNAME} > /etc/cloud/cloud.cfg.d/99_hostname.cfg
echo fqdn: ${FQDN} >> /etc/cloud/cloud.cfg.d/99_hostname.cfg

## install salt-minion
yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-2015.8-2.el7.noarch.rpm >/dev/null 2>&1
yum -y clean expire-cache >/dev/null 2>&1
yum -y install salt-minion >/dev/null 2>&1
(umask 027 && mkdir /etc/salt/minion.d)
(umask 027 && touch /etc/salt/minion.d/_bootstrap.conf)
cat > /etc/salt/minion.d/_bootstrap.conf <<EOF
master: salt.ibrsp.org
EOF
systemctl enable salt-minion >/dev/null 2>&1
systemctl start salt-minion >/dev/null 2>&1

## post the minion key fingerprint to the instance system log
sleep 30; salt-call key.finger --local
