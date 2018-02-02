{%- from "moodle/lib.jinja" import to_php with context -%}
{%- from "moodle/map.jinja" import moodle with context -%}
<?php
unset($CFG);
global $CFG;
$CFG = new stdClass();

{%- for key, value in moodle.config|dictsort if value is not none %}
$CFG->{{ key }} = {{ to_php(value) }};
{%- endfor %}

require_once(__DIR__ . '/lib/setup.php');
