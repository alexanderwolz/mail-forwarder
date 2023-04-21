#!/bin/bash
# Copyright (C) 2023 Alexander Wolz <mail@alexanderwolz.de>

if [ "$#" -gt 2 ]; then
    echo "Too many arguments (please specify FROM and TO)"
    exit 1
fi

if [ "$#" -lt 2 ]; then
    echo "please specify FROM and TO"
    exit 1
fi

SUBJECT=Test
FROM="$1"
RECIPIENT="$2"

/usr/sbin/sendmail "$RECIPIENT" <<EOF
subject:$SUBJECT
from:$FROM

Example Message at $(date)
EOF

echo "Sent test emails from $FROM to $RECIPIENT via sendmail"
exit 0
