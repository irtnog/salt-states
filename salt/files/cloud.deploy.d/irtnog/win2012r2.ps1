{% set cloud = salt['pillar.get']('salt:cloud', {}) -%}

## pre-requisites
(New-Object System.Net.WebClient).DownloadFile("$pwd\AWSToolsAndSDKForNet.msi", "http://sdk-for-net.amazonwebservices.com/latest/AWSToolsAndSDKForNet.msi")
Start-Process "$pwd\AWSToolsAndSDKForNet.msi" -ArgumentList "/qn" -Wait
Import-Module AWSPowerShell
{% if 'irtnog_ec2_whoami_key' in cloud -%}
$AWS_ACCESS_KEY_ID={{ cloud.get('irtnog_ec2_whoami_key')|yaml_dquote }}
$AWS_SECRET_ACCESS_KEY={{ cloud.get('irtnog_ec2_whoami_secret')|yaml_dquote }}
{%- endif %}

## determine name from instance tags

## set the hostname
Rename-Computer -Force -NewName $hostname

## install salt-minion
