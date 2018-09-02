#!/bin/bash
set -e

rm -f /var/run/postgresql/*.pid
/etc/init.d/postgresql start
#msfrpcd -U msf -P msf -a 127.0.0.1 -p 55554 -S


/bin/bash
