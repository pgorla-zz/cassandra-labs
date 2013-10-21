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

    cqlsh> SELECT keyspace_name, columnfamily_name
        FROM system.schema_columnfamilies ;


Lab 3: Creating New Column Families
-----------------------------------
Before we add data, we must first create a keyspace and column family.
You can think of a keyspace as analagous to a relational database,
and a column family a table in the database.

Multiple keyspaces can exist in a single cluster, but this is generally
not recommended.

Create a new keyspace, Candyshop

    cqlsh> CREATE KEYSPACE "CandyShop"
    WITH replication = 
    {'class': 'SimpleStrategy', 'replication_factor': 1 } ;

Check back on your shell where the Cassandra client is running in the
foreground. What has happened?

You should see Cassandra reflect the newly-written keyspace, and you
should also see the Memtable being flushed.

    cqlsh> USE "CandyShop";

Now that we have a keyspace, we can create a column family.

    cqlsh:CandyShop> CREATE COLUMNFAMILY daily_visitors
    (day text,
    time timestamp,
    visitors text,
    PRIMARY KEY (day, time)) ;

Notice the difference in data model here: each row is a day, and each
column will be an hour.

NOTE: Pay attention to the single quotes; CQLsh does not accept double quotes.

    cqlsh:CandyShop> INSERT INTO daily_visitors
    (day, time, visitors)
    VALUES ('Monday', '2013-01-01 15:00+0000', '12');

    cqlsh:CandyShop> INSERT INTO daily_visitors
    (day, time, visitors)
    VALUES ('Monday', '2013-01-01 21:00+0000', '20');

    cqlsh:CandyShop> INSERT INTO daily_visitors
    (day, time, visitors)
    VALUES ('Tuesday', '2013-01-02 05:00+0000', '56');

Now select back the information.

    cqlsh:CandyShop> SELECT * FROM daily_visitors ;

     day     | time                     | visitors
    ---------+--------------------------+----------
      Monday | 2013-01-01 16:00:00+0100 |       12
      Monday | 2013-01-01 22:00:00+0100 |       20
     Tuesday | 2013-01-02 06:00:00+0100 |       56

We can even specify a specific day to retrieve.

    cqlsh:CandyShop> SELECT visitors
    FROM daily_visitors WHERE day = 'Monday' ;

    visitors
    --------
    12
    20

Since we used a composite column for our schema, we can also specify
both components when retrieving a row.

    cqlsh:CandyShop> SELECT visitors
    FROM daily_visitors
    WHERE day = 'Monday' and time = '2013-01-01 16:00:00+0100';

    visitors
    --------
    12


Extra Credit
------------
Return to `system.schema_columnfamilies`, and review what has changed
since adding information.
