#!/bin/bash
source `dirname "$0"`/common.sh

su - root -c "mkdir -p $DATA_DIR"
su - root -c "mkdir -p $LOG_DIR"

EBS_AVAILABLE=lsblk | grep xvdf | awk '{print $6}'
ALREADY_MOUNTED=lsblk | grep xvdf | awk '{print $7}'

if [ -z "$ALREADY_MOUNTED" ]; then # Not mounted
    if [ -n "$EBS_AVAILABLE" ]; then # But EBS is available
        echo EBS available, mouting... 
        su - root -c "mkfs -t ext4 /dev/xvdf"
        su - root -c "mount /dev/xvdf $DATA_DIR"

        echo Configuring EBS automount on reboot
        su - root -c "cp /etc/fstab /etc/fstab.bak"
        su - root -c "echo '/dev/xvdf    $DATA_DIR    ext4    defaults,nofail    0    0' >> /etc/fstab"
        sudo mount -a
    else 
        echo Not EBS storage available
    fi
else
    echo $DATA_DIR EBS is already mounted
fi


