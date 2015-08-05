5 AUG 2015
This version works and will set up a Spark 1.4.1 Cluster over a
Hadoop (YARN) 2.7.1 cluster.

N.b., 
 - there is a problem accessing S3 via Spark.  This is not a big deal, 
   since we can access S3 via HDFS.
 - The AWS keys need to be added once the cluster is up and running. They
   have not been included in the templates in our fork of spark-ec2.


