Data Modeling
===============

In the last lab, we looked at basic commands using the command line `cqlsh`
tool. Now, we will examine the Thrift-based `cassandra-cli`, along with
`cqlsh`.

We can begin data modeling in Cassandra.
There are two distinct ways of approaching data modeling: Thrift and CQL.

Cassandra was originally based on the Thrift protocol, which introduced
the Thrift data model. The Cassandra Query Language (CQL) was added
to Cassandra 0.8, and the binary protocol in Cassandra 1.2.

By default, CQL uses Thrift strictly as a synchronous transport layer.
The binary protocol exclusively supports CQL and is asynchronous, and
allows Cassandra to register for server notifications.

Thrift closely models the structure of how data is stored on disk,
and is important to understand when using Cassandra.

Lab 1. The Thrift Data Model
-----------------------------
The Thrift data model is composed of cells with values, forming the
basis of Cassandras BigTable data model.

    Column Family
    ---------------------------------------
     row1: {col1:val1:time:TTL, ... }
     row2: {col1:val1:time:TTL, ... }
    ---------------------------------------

The cell-value pairs are the fundamental components of the Cassandra
data model.  We will use Thrift to examine how CQL constructs are
physically represented on disk.

    $ bin/cassandra-cli
    Connected to: "Test Cluster" on 127.0.0.1/9160

List out the commands in the cli client.

    [default@unknown] help ;
    [default@unknown] show cluster name ;

Now lets examine the tables we created in the last lab. Note that unlike
`cqlsh`, `cassandra-cli` is case-insensitive, and does not use quotes.

    [default@unknown] use Patisserie ;
    Authenticated to keyspace: Patisserie

    [default@Patisserie] list daily_visitors ;

You should now see two different RowKeys: one for Monday and one for
Tuesday. A rowkey (partition key) is what determines the physical
placement of a datum in Cassandra.

Since this data was added using CQL3, we can only add data to this column
family with CQL and not Thrift.


Lab 2. CQL
------------
Introduced in 0.8, CQL has rapidly grown to be the de-facto data model
for new Cassandra projects. CQL provides many useful abstractions for a
flexible schema.

With CQL we adapt our terminology. 'Table' and 'Column family' are
synonymous, yet we use the former for CQL-related topics and the latter
for Thrift.

    Thrift                              CQL

    row                                 partition

    column                              cell

    cell name component / value         column

    group of cells with shared          row
      component prefixes

In the figure below, note the pseudo-schema that displays empty
values in the table. In rigid-schema structures, an empty value is
earmarked as null and stored in the database, still using up space.
Cassandra follows the sparse, wide-row model of BigTable, meaning that
empty values are simply not stored.

    Table

    id    |  col1   |  col2   |  col 3
    ------+---------+---------+-------
    1     |    a    |    b    |    c
    2     |    a    |  null   |    c
 
Lets examine this another way: in a second shell, open up `cqlsh`. 

    $ bin/cqlsh
    Connected to Test Cluster at localhost:9160.

    cqlsh> use "Patisserie" ;

    cqlsh:Patisserie> CREATE TABLE foo (
        id text primary key,
        a text,
        b text
        ) ;

    cqlsh:Patisserie> INSERT INTO foo (id, a) VALUES ('1', '2');
    cqlsh:Patisserie> INSERT INTO foo (id, b) VALUES ('3', '2');
    cqlsh:Patisserie> SELECT * FROM foo;

Now, with `cassandra-cli`.

    [default@Patisserie] list foo ;
    -------------------
    RowKey: 3
    => (name=, value=, timestamp=1382924748347000)
    => (name=b, value=32, timestamp=1382924748347000)
    -------------------
    RowKey: 1
    => (name=, value=, timestamp=1382924740619000)
    => (name=a, value=32, timestamp=1382924740619000)

Note that there are two entries for each partition, which only have
one column each. This is because CQL keeps track of all rows, regardless
of whether they have values in them. Originally, if you added data with
just the partition key, that row would get earmarked for deletion and
garbage-collected on compaction. Now, the rows are preserved.

    cqlsh:Patisserie> INSERT INTO foo (id) VALUES ('single-id') ;
    cqlsh:Patisserie> SELECT * FROM foo ;

    [default@Patisserie] list foo ;


Lab 3. CQL Collections
---------------------

CQL3 added collections to its data types, so now you can create tables
with multi-valued columns.


Lists

    cqlsh:Patisserie> CREATE TABLE customer_purchases
        (customer text,
        day text,
        item list<text>,
        PRIMARY KEY (customer,day) ) ;


    cqlsh:Patisserie> INSERT INTO customer_purchases (customer, day, item)
        VALUES ('ylaurent', 'm', ['rivoli', 'rivoli', 'javanais']);
    cqlsh:Patisserie> INSERT INTO customer_purchases (customer, day, item)
        VALUES ('cchanel', 'm', ['pain au chocolat']);
    cqlsh:Patisserie> INSERT INTO customer_purchases (customer, day, item)
        VALUES ('pcardin', 'w', ['croissant', 'mille feuille']);

Each value is represented as a column with a special composite column
comparator.
    
    [default@Patisserie] list customer_purchases ;
    RowKey: ylaurent
    => (name=m:, value=, timestamp=1382926135738000)
    => (name=m:item:e637b1a03f7511e38900b19b5903dc68, value=7269766f6c69,
        timestamp=1382926135738000)
    => (name=m:item:e637b1a13f7511e38900b19b5903dc68, value=7269766f6c69,
        timestamp=1382926135738000)
    => (name=m:item:e637d8b03f7511e38900b19b5903dc68, value=6a6176616e616973,
        timestamp=1382926135738000)

Although we cannot read the values, note that the insert order is preserved
and duplicates are saved as well.

Sets

Sets discard duplicates, and return values in sorted order. 

    cqlsh:Patisserie> DROP TABLE customer_purchases ;
    cqlsh:Patisserie> CREATE TABLE customer_purchases
        (customer text,
        day text,
        item set<text>,
        PRIMARY KEY (customer,day) ) ;


    cqlsh:Patisserie> INSERT INTO customer_purchases (customer, day, item)
        VALUES ('ylaurent', 'm', {'rivoli', 'rivoli', 'javanais'});
    cqlsh:Patisserie> INSERT INTO customer_purchases (customer, day, item)
        VALUES ('cchanel', 'm', {'pain au chocolat'});
    cqlsh:Patisserie> INSERT INTO customer_purchases (customer, day, item)
        VALUES ('pcardin', 'w', {'croissant', 'mille feuille'});

    [default@Patisserie] list customer_purchases ;
    RowKey: ylaurent
    => (name=m:, value=, timestamp=1382926590338000)
    => (name=m:item:6a6176616e616973, value=, timestamp=1382926590338000)
    => (name=m:item:7269766f6c69, value=, timestamp=1382926590338000)

Maps

Maps offer a form of nesting using an ordered map, similar to a set.

    cqlsh:Patisserie> DROP TABLE customer_purchases ;
    cqlsh:Patisserie> CREATE TABLE customer_purchases
        (customer text,
        day text,
        item map<text,int>,
        PRIMARY KEY (customer,day) ) ;

    cqlsh:Patisserie> INSERT INTO customer_purchases (customer, day, item)
        VALUES ('ylaurent', 'm', {'rivoli': 5, 'javanais': 1});
    cqlsh:Patisserie> INSERT INTO customer_purchases (customer, day, item)
        VALUES ('cchanel', 'm', {'pain au chocolat': 3});
    cqlsh:Patisserie> INSERT INTO customer_purchases (customer, day, item)
        VALUES ('pcardin', 'w', {'croissant': 6, 'mille feuille': 12});


    cqlsh:Patisserie> SELECT * FROM customer_purchases ;
     customer | day | item
    ----------+-----+---------------------------------------
      pcardin |   w | {'croissant': 6, 'mille feuille': 12}
     ylaurent |   m |          {'javanais': 1, 'rivoli': 5}
      cchanel |   m |               {'pain au chocolat': 3}

When we look at how maps are stored on disk, we see that each map entry
is represented by a column in Cassandra.

    [default@Patisserie] list customer_purchases ;
    RowKey: pcardin
    => (name=w:, value=, timestamp=1382927399914000)
    => (name=w:item:63726f697373616e74, value=00000006,
        timestamp=1382927399914000)
    => (name=w:item:6d696c6c6520666575696c6c65, value=0000000c,
        timestamp=1382927399914000)



Cons

While collections provide a lot of flexibility, there are a few downsides
to using them.

- Secondary indexes are not supported on collections yet.
- Collections cannot be nested.
- When selecting a collection, that entire value is retrieved. Maps, lists,
  and sets, therefore, do not provide the same level of scalability as a
  clearly defined data model.
- Deleting either an element in the collection or the entire collection
  requires a query. Consider performance implications.


Extra Credit
------------
When using composite keys, you have to store the column name for
each column that you add. This greatly increases the amount of space
required for each row, so you can compact the storage to fit into a smaller
space. The downside to this is that you cannot add or remove rows from
column families with compact storage.


With COMPACT STORAGE, each logical row corresponds to exactly one physical column.

http://www.datastax.com/dev/blog/schema-in-cassandra-1-1


More details on the differences between CQL and Thrift can be found here:
http://www.datastax.com/dev/blog/cql3-for-cassandra-experts


Dynamic Rows in CQL
-------------------
There has been some confusion over whether CQL supports dynamic colummns.
The short answer is: it does. The long answer is written in this clear
blog post by Jonathan Ellis.
http://www.datastax.com/dev/blog/does-cql-support-dynamic-columns-wide-rows
