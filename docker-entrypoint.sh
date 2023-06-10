#!/bin/bash
set -e

if [[ "$1" = 'xrdp' ]]; then
  /sbin/init
  exec sudo /etc/init.d/xrdp start
fi

exec "$@"

