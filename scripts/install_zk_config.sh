#!/bin/bash
source `dirname "$0"`/common.sh

echo Applying Zookeeper config `dirname "$0"`/$ZK_CONFIG_TYPE/$ZK_NODE_TYPE.properties
su - root -c "cp `dirname "$0"`/$ZK_CONFIG_TYPE/$ZK_NODE_TYPE.properties $KAFKA_HOME/config/zookeeper.properties"

# The instance identity document contains eht0 attached IP, which is not what we want,
# we want the one assigned to eth1 (the code has a fallback to eth0 altough we don't expect it to be the case)
ETH0IP=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep privateIp | awk -F\" '{print $4}')
echo eth0 IP: $ETH0IP
ETH0MAC=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/ | head -n 1) #1st line
echo mac0: $ETH0MAC
ETH1MAC=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/ | head -n 2 | tail -1) #2nd line
echo mac1: $ETH1MAC
IP0=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$ETH0MAC/local-ipv4s)
echo IP0: $IP0
IP1=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$ETH1MAC/local-ipv4s)
echo IP1: $IP1

PRIVATE_IP=$IP1
if [[ (-z "$IP1")  || ( "$IP1" == "$ETH0IP" ) ]]; then
    PRIVATE_IP=$IP0
fi

echo Private IP: $PRIVATE_IP
if [ -z "$PRIVATE_IP" ]; then
    echo Could not find private IP
    exit 1
fi

# TODO: Get the IP:Server IDs mapping, for now assume only one host
SERVER_ID=1
# The main assumption is that the IP determins the ID, and we control the IPs even when chaning instances
#SERVER_ID=$(cat $KAFKA_HOME/config/zookeeper.properties | grep $PRIVATE_IP | awk -F"=" '{print $1}' | awk -F"." '{print $2}')
echo Server ID: $SERVER_ID
if [ -z "$SERVER_ID" ]; then
    echo Could not find server Id
    exit 1
fi
echo Generating zookeeper myid $SERVER_ID file in $DATA_DIR/myid   ..
su - root -c "echo $SERVER_ID > $DATA_DIR/myid"

#echo Replacing $PRIVATE_IP with 0.0.0.0 in the config
CONFIG=$(cat $KAFKA_HOME/config/zookeeper.properties)
# TODO: once we have more IPs, we will need to replace the current host IP with 0.0.0.0, for now just emit 0.0.0.0
#echo ${CONFIG/$PRIVATE_IP/0.0.0.0} | tr ' ' '\n' > /tmp/zookeeper-local.properties
echo $CONFIG | tr ' ' '\n' > /tmp/zookeeper-local.properties
echo "server.$SERVER_ID=0.0.0.0" >> tmp/zookeeper-local.properties
su - root -c "cp /tmp/zookeeper-local.properties $KAFKA_HOME/config/zookeeper-local.properties"
