KafkaFile=kafka_2.12-1.1.0.tgz
KafkaInstallDirectory=`(basename $KafkaFile .tgz)`
ZKSetup=default # TODO: make an argument
ZKSetupNode=quorum # TODO: make an argument

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')

export ZK_CONFIG_TYPE=$ZKSetup
export ZK_NODE_TYPE=$ZKSetupNode
export KAFKA_HOME=/app/kafka/$KafkaInstallDirectory
export PATH=~/bin:$PATH:$KAFKA_HOME/bin

#Data and logs should be defined on separate volumes (also need to update the properties to reflect that)
DATA_DIR=/app/kafka/data
LOG_DIR=$KAFKA_HOME/txnLog