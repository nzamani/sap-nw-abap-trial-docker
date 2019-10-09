#!/bin/bash
DOCKER_PROCESS=$( docker ps | grep nwabap  | sed 's/ .*//' )

docker exec $DOCKER_PROCESS "/usr/sbin/uuidd"
docker exec --user npladm $DOCKER_PROCESS /bin/bash -lc "/usr/sap/NPL/SYS/exe/uc/linuxx86_64/startsap ALL"