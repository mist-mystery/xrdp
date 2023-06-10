#!/bin/bash
set -e

# echo "USER: $(id -u)"
if [[ "$1" = "systemd" ]]; then
  echo "exec /sbin/init init"
  exec /sbin/init init
fi

echo "exec $@"
exec "$@"

