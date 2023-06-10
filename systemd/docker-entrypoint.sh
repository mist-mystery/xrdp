#!/bin/bash
set -e

if [[ "$1" = "systemd" ]]; then
  echo "exec /sbin/init init"
  exec /sbin/init init
fi

echo "exec $@"
exec "$@"

