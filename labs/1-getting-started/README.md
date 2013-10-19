Getting Started
===============

In this lab, we will set up our first one-node Cassandra cluster, use
the Cassandra Query Language, and add data into Cassandra.


Lab 1: Start Cassandra
----------------------
Unpack the vanilla Cassandra package.

    $ tar xzvf apache-cassandra-1.2.10-bin.tar.gz
    $ cd apache-cassandra-1.2.10
    $ ls conf/

We will now examine the `conf/` directory.

* cassandra.yaml - The main configuration file for Cassandra. This yaml
contains all directives to pass into the system on how to connect to
other nodes, and other cluster configurations.

* log4j-{server,tools}.properties - Configuration files for setting log
levels and logging directories.

* cassandra-rackdc.properties - Use with GossipingPropertyFileSnitch, if
specified.

* cassandra-topology.properties - Use with PropertyFileSnitch, if specified.

Now we start Cassandra.

    $ bin/cassandra -f
    ...
     INFO 01:34:36,623 Using synchronous/threadpool thrift server on localhost : 9160
     INFO 01:34:36,624 Listening for thrift clients...

This starts a Cassandra process in the foreground, where you can examine
traffic patterns as they appear on screen. You should not see any errors
occur on screen.

If you had multiple nodes running concurrently, you would be able to see
them join the system.

Congratulations! You've started your first Cassandra node.


Lab 2: Cassandra Query Language
-------------------------------
With your one-node Cassandra cluster running in a separate shell, start
CQLsh from the same Cassandra directory.

    $ bin/cqlsh

    Connected to Test Cluster at localhost:9160.
    [cqlsh 3.1.7 | Cassandra 1.2.10 | CQL spec 3.0.0 | Thrift protocol 19.36.0]
    cqlsh>

You now have a CQL shell to pass in commands. CQL is very similar to the
relational SQL syntax, so the directives should feel the same. In the
empty shell, tap `tab` a couple of times to auto-complete the full list
of commands.

    cqlsh> [tab]
    ?            CONSISTENCY  DESC         HELP         SHOW         USE
    ALTER        COPY         DESCRIBE     INSERT       SOURCE       exit
    ASSUME       CREATE       DROP         LIST         TRACING      quit
    BEGIN        DEBUG        EXPAND       REVOKE       TRUNCATE
    CAPTURE      DELETE       GRANT        SELECT       UPDATE

Two keyspaces already exist in your cluster: system, and system traces.
These keyspaces manage configurations for all nodes in the cluster.

    cqlsh> DESCRIBE KEYSPACES ;
    system  system\_traces

Analyze one of the keyspaces, and look at the column families listed in
the keyspace.

    cqlsh> DESCRIBE KEYSPACE system ;

Note the existence of a column family called `schema_columnfamilies`. You
can also use the describe command on columnfamilies.

    cqlsh> DESCRIBE COLUMNFAMILY system.schema_columnfamilies ;

This column family in particular contains the schemas for all column
families in the cluster. All distributed systems have a configuration
manager; Cassandra manages the schemas internally. Any new column
families you create will be included in this column family.

Selecting data is quite similar to SQL.

    cqlsh> SELECT *
        FROM system.schema_columnfamilies
        LIMIT 1 ;

    cqlsh> SELECT keyspace_name, columnfamily_name \
        FROM system.schema_columnfamilies ;


Lab 3: Adding Data
------------------

