#!/usr/bin/env bash

export SPARK_LOCAL_DIRS="{{spark_local_dirs}}"

# Standalone cluster options
export SPARK_MASTER_OPTS="{{spark_master_opts}}"
if [ -n {{spark_worker_instances}} ]; then
  export SPARK_WORKER_INSTANCES={{spark_worker_instances}}
fi
export SPARK_WORKER_CORES={{spark_worker_cores}}

export HADOOP_HOME="/root/persistent-hdfs"
export SPARK_MASTER_IP={{active_master}}
export MASTER=`cat /root/spark-ec2/cluster-url`
export SPARK_PRIVATE_DNS=`wget -q -O - http://169.254.169.254/latest/meta-data/local-hostname`
export HDFS_URL=hdfs://$SPARK_PRIVATE_DNS:9010

export SPARK_SUBMIT_LIBRARY_PATH="$SPARK_SUBMIT_LIBRARY_PATH:/root/persistent-hdfs/lib/native/"
export SPARK_SUBMIT_CLASSPATH="$SPARK_CLASSPATH:$SPARK_SUBMIT_CLASSPATH:/root/persistent-hdfs/conf"
export SPARK_LOCAL_DIRS="/vol0/spark, /vol1/spark"

# Bind Spark's web UIs to this machine's public EC2 hostname otherwise fallback to private IP:
SPARK_PUBLIC_DNS=`wget -q -O - http://169.254.169.254/latest/meta-data/public-hostname`
if [[ -z "$SPARK_PUBLIC_DNS" ]]; then
  SPARK_PUBLIC_DNS=`wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4`
fi
export SPARK_PUBLIC_DNS

# Used for YARN model
export YARN_CONF_DIR="/root/persistent-hdfs/conf"

# Set a high ulimit for large shuffles, only root can do this
if [ $(id -u) == "0" ]
then
    ulimit -n 1000000
fi
