#!/bin/sh

usage() {
  >&2 echo "Usage: volume-backup <backup|restore>"
  exit 1
}

backup() {
    if [ -z "$(ls -A /volume)" ]; then
       >&2 echo "Volume is empty or missing, check if you specified a correct name"
       exit 1
    fi

    tar -cf - -C /volume ./ | lz4
}

restore() {
    rm -rf /volume/* /volume/..?* /volume/.[!.]*
    lz4 -dc --no-sparse - | tar -C /volume/ -xf -
}

# Needed because sometimes pty is not ready when executing docker-compose run
# See https://github.com/docker/compose/pull/4738 for more details
# TODO: remove after above pull request or equivalent is merged
sleep 1

if [ $# -ne 2 ]; then
    usage
fi

OPERATION=$1

case "$OPERATION" in
"backup" )
backup
;;
"restore" )
restore
;;
* )
usage
;;
esac
