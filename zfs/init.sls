{%- for fs, options in salt['pillar.get']('zfs:file_systems', {})|dictsort %}
{{ 'zfs_file_system_%s'|format(fs)|yaml_encode }}:
  zfs.filesystem_present:
    - name: {{ fs|yaml_encode }}
{%-   if 'create_parent' in options %}
    - create_parent: {{ options.pop('create_parent')|yaml_encode }}
{%-   endif %}
{%-   if 'cloned_from' in options %}
    - cloned_from: {{ options.pop('cloned_from')|yaml_encode }}
{%-   endif %}
{#- The rest of the dict gets passed to the properties kwarg. #}
{%-   if options|length > 0 %}
    - properties: {{ options|yaml }}
{%-   endif %}
{%- endfor %}
