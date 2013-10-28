Analytics à Boulangerie
-----------------------

Now we will examine a real-world model: determining throughput of a
busy Parisian patisserie.


Lab 1: Setup
------------

First, we need to set up our schemas and create some column
families.

    cqlsh> CREATE KEYSPACE "Oberweis" WITH replication = 
        {'class': 'SimpleStrategy', 'replication_factor': 1} ;

    cqlsh> USE "Oberweis"; 

    cqlsh:Oberweis> CREATE TABLE "daily_purchases"
        day 
        






Next, unpack the Python CQL driver and add it to our working namespace.

    $ tar xzvf cql-1.4.0
    $ mv cql-1.4.0/cql .
    $ rm -fr cql-1.4.0
