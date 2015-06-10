#!/bin/sh

## unpack the password database editing script into a temp file
TEMPSCRIPT=$(mktemp /tmp/enable-passwd-map.XXXXXXXXXXXXXXXX) || exit 1
(b64decode -p | gzcat > ${TEMPSCRIPT}) <<'1dcbc09f3596d370a8e352f1f450e41a'
begin-base64 644 script.gz
H4sICAPFdlMAA3NjcmlwdAB9j7FOQzEMRXd/xW2LlBaqPiq2ULG1EgNiYWBDeYnTREqTkuRR9e9J
H2Vg4Xq0z7E9m3S9j11xRN5iArvPfIS4k7ey5b6VlALTm/UUT+gMf3VxCOER1XEktLD56W42Yvu6
E6ToD0srOtEntRaN4zPsnt9fthJvzhcUl4ZgoqjoGZE1l6LyeYl+qLApo6QDI7MqKS7bpvl6cZWY
xOWCaafini/XwPrAOCTjrdeq+hRRfaOb5Xj6YOPr/GHxy10tzWz+Y3XKmXUN59UI1DRoN35L1tM3
IbxTVzoBAAA=
====
1dcbc09f3596d370a8e352f1f450e41a
chmod +x ${TEMPSCRIPT}		# make the script executable
env EDITOR=${TEMPSCRIPT} vipw	# execute password database changes
RETVAL=$?			# save vipw exit status
rm ${TEMPSCRIPT}		# clean up
exit ${RETVAL}
