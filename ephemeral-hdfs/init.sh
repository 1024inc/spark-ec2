#!/bin/bash

pushd /root > /dev/null

if [ -d "ephemeral-hdfs" ]; then
  echo "Ephemeral HDFS seems to be installed. Exiting."
  return 0
fi

case "$HADOOP_MAJOR_VERSION" in
  1)
    wget http://s3.amazonaws.com/spark-related-packages/hadoop-1.0.4.tar.gz
    echo "Unpacking Hadoop"
    tar xvzf hadoop-1.0.4.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-1.0.4/ ephemeral-hdfs/
    sed -i 's/-jvm server/-server/g' /root/ephemeral-hdfs/bin/hadoop
    ;;
  2) 
    wget http://s3.amazonaws.com/spark-related-packages/hadoop-2.0.0-cdh4.2.0.tar.gz  
    echo "Unpacking Hadoop"
    tar xvzf hadoop-*.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-2.0.0-cdh4.2.0/ ephemeral-hdfs/

    # Have single conf dir
    rm -rf /root/ephemeral-hdfs/etc/hadoop/
    ln -s /root/ephemeral-hdfs/conf /root/ephemeral-hdfs/etc/hadoop
    ;;
  *)
    wget https://www.apache.org/dist/hadoop/core/hadoop-2.7.1/hadoop-2.7.1.tar.gz
    echo "Unpacking Hadoop"
    tar xvzf hadoop-*.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-2.7.1/ ephemeral-hdfs/

    # Have single conf dir
    rm -rf /root/ephemeral-hdfs/etc/hadoop/
    ln -s /root/ephemeral-hdfs/conf /root/ephemeral-hdfs/etc/hadoop
    ;;

esac
cp /root/hadoop-native/* ephemeral-hdfs/lib/native/
/root/spark-ec2/copy-dir /root/ephemeral-hdfs

popd > /dev/null
