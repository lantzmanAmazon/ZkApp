#!/usr/bin/python
import socket

zookeeper_id = int(socket.inet_aton(socket.gethostbyname(socket.gethostname())).encode('hex')[-4:],16)
file = open("/tmp/zookeeper/myid", "w")
file.write('ZOOKEEPERID={}'.format(str(zookeeper_id)))
file.close()

print('ZOOKEEPERID={}'.format(zookeeper_id))