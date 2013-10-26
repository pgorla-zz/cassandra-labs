Data Modeling
=============

We can now start examining how to begin data modeling in Cassandra.
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



Lab X. CQL
------------


Lab X. CQL Data Types
---------------------


