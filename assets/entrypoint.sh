#!/bin/bash

set -e

echo "Starting container .."
COMMAND="/usr/bin/shellinaboxd --debug --no-beep --disable-peer-check -u ${SIAB_USER} -g ${SIAB_GROUP} -c /var/lib/shellinabox -p ${PORT} --user-css ${SIAB_USERCSS}"

if [ "$@" = "shellinabox" ]; then
	echo "Executing: ${COMMAND}"
	exec ${COMMAND}
else
	echo "Not executing: ${COMMAND}"
	echo "Executing: ${@}"
	exec $@
fi
