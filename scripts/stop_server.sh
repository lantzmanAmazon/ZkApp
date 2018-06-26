#!/bin/bash
echo Stopping ...
source `dirname "$0"`/common.sh

# TODO: Actually stop the previous version, this might require symlinks to "current version" or something
$KAFKA_HOME/bin/zookeeper-server-stop.sh || true
