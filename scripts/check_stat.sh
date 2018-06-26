#!/bin/bash
source `dirname "$0"`/common.sh

echo stat | nc localhost 2181
SANITY=$(echo stat | nc localhost 2181 | grep "Node count:")

if [ -z "$SANITY" ]; then # Should be visible when started correctly
    echo Zookeeper failed to start !
    echo Config: "$(cat $KAFKA_HOME/config/zookeeper-local.properties)"
    echo Instance: "$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document)"
    exit 1
fi
