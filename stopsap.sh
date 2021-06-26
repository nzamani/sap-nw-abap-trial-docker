#!/bin/bash
DOCKER_PROCESS=$( docker ps | grep nwabap  | sed 's/ .*//' )

docker exec --user npladm $DOCKER_PROCESS /bin/bash -lc "/usr/sap/NPL/SYS/exe/uc/linuxx86_64/stopsap ALL"