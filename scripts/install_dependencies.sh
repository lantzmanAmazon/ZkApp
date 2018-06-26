#!/bin/bash
source `dirname "$0"`/common.sh

echo Installing Java8
su - root -c "yum install -y java-1.8.0-openjdk-devel"
su - root -c "alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java"

echo Extracting Kafka to $KAFKA_HOME ...
su - root -c 'mkdir -p /app/kafka'
su - root -c  "cp `dirname "$0"`/../$KafkaFile /app/$KafkaFile"
tar -zxvf /app/$KafkaFile -C /app/kafka
