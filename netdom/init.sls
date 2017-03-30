#### NETDOM/JOIN.SLS --- Join an AD domain using netdom.exe

{%- if salt.cmd.run('(gwmi win32_computersystem).partofdomain', shell='powershell')
       and salt.pillar.get('netdom:join') is not None %}

netdom_join:
  cmd_run:
    - name:
        {{ 'netdom join %s /domain:%s /ou:"%s" /userd:%s /passwordd:%s /reboot:%s'|format(
            grains.host,
            salt.pillar.get('netdom:join:domain'),
            salt.pillar.get('netdom:join:ou')|join(','),
            salt.pillar.get('netdom:join:user'),
            salt.pillar.get('netdom:join:password'),
            salt.pillar.get('netdom:join:reboot', 60),
        )|yaml_encode }}

{%- endif %}

#### NETDOM/JOIN.SLS ends here.
