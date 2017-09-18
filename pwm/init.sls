pwm:
  file.directory:
    - name: /opt/pwm/data
    - user: tomcat
    - group: tomcat
    - dir_mode: 700
    - file_mode: 600
    - makedirs: True

  archive.extracted:
    - name: /opt/pwm
    - source: https://www.pwm-project.org/artifacts/pwm/pwm-1.8.0-SNAPSHOT-2017-09-13T17:23:36Z-release-bundle.zip
    - source_hash: sha512=634189404cdb1c57f2911fb4cb9531abf8ca3e58f8a673a4bd926d11520cca0dffbc158b208801b43d7ab1d592cd3b24bef5375b46ee646c4417b0652c501aa1
    - extract_perms: False
    - require:
        - file: pwm
