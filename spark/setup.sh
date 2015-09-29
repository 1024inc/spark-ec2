#!/bin/bash

/root/spark-ec2/copy-dir /root/spark

/root/persistent-hdfs/sbin/start-all.sh && /root/persistent-hdfs/sbin/restart-nfs.sh
/root/spark/sbin/start-all.sh

