#!/bin/sh

if ! fgrep '+:*:::::' /etc/passwd > /dev/null; then
    env EDITOR=ex vipw <<EOF
a
+:*:::::
.
w
q
EOF
    RETVAL=$?
    exit ${RETVAL}
fi
