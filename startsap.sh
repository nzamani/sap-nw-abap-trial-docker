#!/bin/bash
DOCKER_PROCESS=$( docker ps | grep nwabap  | sed 's/ .*//' )

if [ !DOCKER_PROCESS ]; then
    DOCKER_PROCESS=$(docker container ls --all  | grep nwabap  | sed 's/ .*//' )
    docker restart $DOCKER_PROCESS
fi

docker exec $DOCKER_PROCESS "/usr/sbin/uuidd"
docker exec --user npladm $DOCKER_PROCESS /bin/bash -lc "/usr/sap/NPL/SYS/exe/uc/linuxx86_64/startsap ALL"