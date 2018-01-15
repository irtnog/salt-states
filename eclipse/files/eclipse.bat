@echo off

set ECLIPSEDIR="%LOCALAPPDATA%\{{ version ~ '.' ~ point }}"

if not exist %ECLIPSEDIR% (
  mkdir %ECLIPSEDIR%
)

start "Eclipse" "{{ prefix }}\eclipse\eclipse.exe" -configuration %ECLIPSEDIR%
