Hello, Word Count
==================

To get started with DSE Hadoop, we first need to set the stage.

Stop the running Cassandra cluster, and start a Cassandra analytics
node and job tracker.

    $ bin/dse cassandra -t -j

You should be able to start a new task tracker and job tracker node
without any errors on screen.

Lab 1: Running Wordcount
------------------------
To make sure everything works, follow along with the wordcount example
provided in the `demos/` directory.

Open `wordcount.sh` and edit the last several lines.

    $ cd demos/wordcount
    $ vi wordcount.sh

Add `$DSE_HOME` to all calls to `bin/dse`.

    $DSE_HOME/bin/dse hadoop fs -rm /wikipedia-sample 2>/dev/null 1>/dev/null
    $DSE_HOME/bin/dse hadoop fs -rmr wc-output 2>/dev/null 1>/dev/null
    $DSE_HOME/bin/dse hadoop fs -put wikipedia-sample /
    $DSE_HOME/bin/dse hadoop jar $EXAMPLE_JAR wordcount /wikipedia-sample wc-output
    $DSE_HOME/bin/dse hadoop fs -ls wc-output

Now run the file.

    $ ./wordcount

This script loads the data into CFS, and runs the standard Hadoop
wordcount example jar over the data.


Lab 2: Running Hive Demo
-----------------------
Now we turn to the Hive demo, located at
http://www.datastax.com/docs/datastax_enterprise3.0/solutions/about_hive

    $ cd demos/portfolio_manager

DSE includes a Hive MapReduce client. Hive can start on any analytics
node, and can query directly against Cassandras data: column families
are mapped directly into Hive tables.

Note: The Hive metastore is kept as a keyspace in Cassandra directly,
so no local client is required.

Start the Hive client.

    $ bin/dse hive

From here, you can interact with Hive as you would normally.

Create a new table, and load the data into CassandraFS.

    hive> CREATE TABLE invites (foo INT, bar STRING)
        PARTITIONED BY (ds STRING);

    hive> LOAD DATA LOCAL
       INPATH 'resources/hive/examples/files/kv2.txt'
       OVERWRITE INTO TABLE invites PARTITION (ds='2008-08-15');

    hive> LOAD DATA LOCAL
       INPATH 'resources/hive/examples/files/kv3.txt'
       OVERWRITE INTO TABLE invites PARTITION (ds='2008-08-08');

    hive> SELECT count(\*), ds FROM invites GROUP BY ds;

This shows how easy it is to get up and running with Hive.

Lab 3: Hive Portfolio Manager
-----------------------------
We access data in Cassandra by creating a database in Hive that maps to
a Cassandra keyspace, and do this by creating them with the same name.

    hive> CREATE DATABASE PortfolioDemo;

    hive> CREATE EXTERNAL TABLE StockHist
        (row_key string, column_name string, value double)
        STORED BY 'org.apache.hadoop.hive.cassandra.CassandraStorageHandler'
        WITH SERDEPROPERTIES ("cassandra.ks.name" = "PortfolioDemo",
            "cassandra.cf.validatorType" = "UTF8Type,UTF8Type,DoubleType"
        );

Next, check that the keyspace and table both exist in Cassandra.

    cqlsh> DESC KEYSPACE "PortfolioDemo" ;


Troubleshooting
---------------
It is a good idea to tail the system log to see what is happening should
you run into errors.

Run this command from a separate window:

    $ tail -f /var/log/cassandra/system.log

* 'IndexOutOfBoundsException' on startup: there is a schema disagreement.
The simplest way to deal with this is to remove the commit log files,
and start the node again.

    $ rm /var/lib/cassandra/commitlog/*

* 'Unable to load realm info from SCDynamicStore' on OS X: 

export HADOOP_OPTS="-Djava.security.krb5.realm= -Djava.security.krb5.kdc="

* 'Does not contain a valid host:port authority:' Check HADOOP_HOME
is correctly set.

* 'FAILED: Error in metadata:' Start Hive with sudo.
    $ sudo bin/dse hive
