#!/bin/bash

DEFAULT_SPARK_GITHUB_REPO="https://github.com/apache/spark"

if [[ $# -eq 0 ]]; then
	echo "Spark git commit hash required: usage upgrade_spark.sh <HASH>"
	exit 1
fi

if [[ -z "$1" ]]; then
	echo "Spark git hash must not be blank."
	exit 1
fi

if  [[ -d "/root/spark" ]]; then
	/root/spark/sbin/stop-all.sh
	/root/persistent-hdfs/sbin/stop-all.sh
fi

# Make sure we are in the spark-ec2 directory
pushd /root/spark-ec2 > /dev/null

#export the git hash for spark
export SPARK_VERSION="$DEFAULT_SPARK_GITHUB_REPO|$1"
export HADOOP_MAJOR_VERSION="YARN"

#Upgrade Spark
if [[ -e spark/init.sh ]]; then
    source spark/init.sh upgrade
	cd /root/spark-ec2  # guard against init.sh changing the cwd
fi

if [[ -e spark/setup.sh ]]; then
    source spark/setup.sh
	cd /root/spark-ec2  # guard against setup.sh changing the cwd
fi

#start the services
/root/persistent-hdfs/sbin/start-all.sh && /root/persistent-hdfs/sbin/restart-nfs.sh
/root/spark/sbin/start-all.sh


popd > /dev/null

exit 0
