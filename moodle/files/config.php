{%- set dbtype = salt['pillar.get']('moodle:dbtype', 'mysqli') -%}
{%- set dblibrary = salt['pillar.get']('moodle:dblibrary', 'native') -%}
{%- set dbhost = salt['pillar.get']('moodle:dbhost', 'localhost') -%}
{%- set dbname = salt['pillar.get']('moodle:dbname', 'moodle') -%}
{%- set dbuser = salt['pillar.get']('moodle:dbuser', 'moodle') -%}
{%- set dbpass = salt['pillar.get']('moodle:dbpass', 'moodle') -%}
{%- set dbpersist = 1 if salt['pillar.get']('moodle:dbpersist', False) else 0 -%}
{%- set dbport = salt['pillar.get']('moodle:dbport', 3306) -%}
{%- set dbsocket = salt['pillar.get']('moodle:dbsocket') -%}
{%- set dbcollation = salt['pillar.get']('moodle:dbcollation', 'utf8mb4_general_ci') -%}
{%- set wwwroot = salt['pillar.get']('moodle:wwwroot', 'http://localhost') -%}
{%- set dataroot = salt['pillar.get']('moodle:dataroot', '/var/lib/moodle') -%}
<?php  // Moodle configuration file

unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype    = '{{ dbtype }}';
$CFG->dblibrary = '{{ dblibrary }}';
$CFG->dbhost    = '{{ dbhost }}';
$CFG->dbname    = '{{ dbname }}';
$CFG->dbuser    = '{{ dbuser }}';
$CFG->dbpass    = '{{ dbpass }}';
$CFG->prefix    = 'mdl_';
$CFG->dboptions = array (
  'dbpersist' => {{ dbpersist }},
  'dbport' => {{ dbport }},
  'dbsocket' => '{{ dbsocket }}',
  'dbcollation' => '{{ dbcollation }}',
);

$CFG->wwwroot   = '{{ wwwroot }}';
$CFG->dataroot  = '{{ dataroot }}';
$CFG->admin     = 'admin';

$CFG->directorypermissions = 0777;

require_once(__DIR__ . '/lib/setup.php');

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!
