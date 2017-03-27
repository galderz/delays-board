#!/usr/bin/env bash

set -e
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

SERVER_ROOT=..
SERVER_HOME=$SERVER_ROOT/infinispan
CLUSTER_SIZE_MAIN="/host=master/server=server-three/subsystem=datagrid-infinispan/cache-container=clustered:read-attribute(name=cluster-size)"


function waitForClusters()
{
  MEMBERS_MAIN=''
  while [ "$MEMBERS_MAIN" != \"3\" ];
  do
    MEMBERS_MAIN=$($SERVER_HOME/bin/ispn-cli.sh -c $CLUSTER_SIZE_MAIN | grep result | tr -d '\r' | awk '{print $3}')
    echo "Waiting for clusters to form (main: $MEMBERS_MAIN)"
    sleep 3
  done
}


rm -drf $SERVER_ROOT/infinispan-server-9.0.0.CR3
echo "Remove old server directory."


unzip $SERVER_ROOT/infinispan-server-9.0.0.CR3-bin.zip -d $SERVER_ROOT
echo "Unzipped server"


cp domain.xml $SERVER_HOME/domain/configuration
cp host.xml $SERVER_HOME/domain/configuration
echo "Configuration files copied to server."


$SERVER_HOME/bin/domain.sh &


waitForClusters
echo "Infinispan servers started."


# Wait until script stopped
while :
do
  sleep 5
done