{%- from "moodle/lib.jinja" import generate_moodle_defaults with context -%}
{%- from "moodle/map.jinja" import moodle with context -%}
<?php
{%- for pluginname in moodle.plugins %}
{{    generate_moodle_defaults(pluginname, moodle[pluginname]|default({})) }}
{%- endfor %}
{{  generate_moodle_defaults('moodle', moodle.defaults) }}
