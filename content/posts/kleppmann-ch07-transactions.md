+++
title = "Kleppmann Chapter 07 - Transactions"
author = ["adam"]
date = 2019-10-25T17:50:20-07:00
lastmod = 2019-10-26T19:54:53-07:00
tags = ["db", "transactions", "scalable", "kleppmann"]
categories = ["kleppmann"]
draft = false
weight = 2000
+++

## Definition of transaction {#definition-of-transaction}

-   a group of several reads and writes
-   logical unit - looks like one operation
-   all or nothing (commit or abort/rollback)


## Who needs transactions {#who-needs-transactions}

-   when you need certain guarantees


## Acid {#acid}

-   Atomicity - abortability (resiliant to faults)
-   Consistency - some invariants about the data must be true
-   Isolation - concurrent transactions are isolated
    -   serializability - too strong
-   Durability - committed means data will not be lost
    -   there is no perfect guarantee


## Base {#base}

-   Basically Available, Soft state, and Eventual consistency


## Single-Object vs Multi-Object Operations {#single-object-vs-multi-object-operations}

-   many writes
    -   atomicity : all written or none
    -   isolation : one transaction cannot see a partial write of another
-   identify multi-object transaction
    -   tie to client's TCP connection - bad
    -   separate transaction id


### Single object writes {#single-object-writes}

-   Storage engine
    -   atomicity : log for crash recovery
    -   isolation : using a lock
    -   atomic operations
        -   increment
        -   compare-and-set


### Multi-object transactions {#multi-object-transactions}

-   when do you need them?
    -   hard because of partitioning
    -   foreign key in another table - make sure references are valid
    -   document data model - require denormalization
        -   when update happens several documents changed
    -   secondary indexes


### Handling errors and aborts {#handling-errors-and-aborts}

-   abort and retry failures
    -   network failures
        -   app doesn't get ACK
    -   overload
        -   exponential backoff - limit number of retries
    -   permanent errors
    -   side effects of transactions : emails
    -   client fails in retry


## Weak Isolation Levels {#weak-isolation-levels}

-   serializable isolation too costly


### Read committed {#read-committed}

-   When reading from DB, only read committed data
    -   no dirty reads, why
        -   don't want to read several modifications in a transaction
        -   don't want to read something that gets rollback
-   Where writing to DB, only overwrite data that has been committed
    -   no dirty writes, why
        -   A and B try to buy same car, listing and sales DB, invoice ovrwrt
        -   read committed does not prevent race condition btw counter increment
        -

| T1 | T2 |
|----|----|
| SA |    |
|    | SB |
|    | IB |
| IA |    |

-   Implementation
    -   row-level locks for duration of transaction
    -   lock for reads slows down the system
        -   instead DB returns only returns committed reads


### Snapshot isolation / repeatable read {#snapshot-isolation-repeatable-read}

-   read committed failures
    -   read skew or nonrepeatable read
        -   Reading from two accounts where transfer happens in between reading
            -   read $500 in one account
            -   transfer happened in between, moving $100 from one account to another
            -   read $400 in another account
    -   Backups
        -   backing up while updates are happening
            -   parts of the backup with have older data -- inconsistent
    -   Analytic queries and integrity checks


## Snapshot isolation {#snapshot-isolation}

-   Transaction reads from a consistent snapshot of the database
    -   sees all the data that was committed at the start of the transactoin
-   Implementation
    -   write locks to prevent dirty writes
    -   no locks on reads
        -   DB keeps different committed versions of an object
            -   multi-version concurrency control (MVCC)
                -   for read committed, snapshot per query
                -   for snapshot isolation, snapshot per transaction
            -   each transaction - increasing transaction ID (txid)
                -   each row has a created\_by field w txid
                -   each row has a deleted\_by field w txid
                    -   GC when no transactions access
        -   txid decides read visibility


### Indexes {#indexes}

-   keep all the versions
    -   let query filter visible ones
    -   GC when no longer visible to any transactions
-   B-tree with append-only/copy-on-write
    -   parent pages are copied and updated to point to new versions
    -   each root is a consistent snapshot of the DB
    -   GC


## Preventing lost updates {#preventing-lost-updates}

-   two reads on same and modify data - clobber
    -   scenario: inc counter, json object, wiki page
-   atomic writes
    -   atomic update counter
    -   atomic write json
    -   exclusive read/write lock on object - cursor stability
-   explicit locking
    -   FOR UPDATE: lock all selected rows
-   alternative detect lost update
-   compare-and-set
    -   send previous read and new value, only set if previous matches


### conflict resolution in multi-leader and leaderless {#conflict-resolution-in-multi-leader-and-leaderless}

-   replicas take writes
-   maintain different versions
-   commutative operations such as inc are ok
-   last write wins (LWW) prone to lost updates


## Write skew {#write-skew}


### doctor call list {#doctor-call-list}

-   crux writing to different rows on on-call table
    -   previously writing to same data


### non-working solutions {#non-working-solutions}

-   atomic single-object don't help
-   automatic detection of lost updates not detectable


### partial solutions {#partial-solutions}

-   constraints, uniqueness or foreign key restrictions, but contraints over
    multiple object is hard
-   explicitly lock all rows with FOR UPDATE


### other examples {#other-examples}

-   Meeting room booking
-   Multiplayer game - lock to prevent two players from moving same figure,
    but does not prevent two users to move simultaneously while avoiding
    some constraint, going to same bathroom
-   Claiming a username - uniqueness constraint
-   Double spending - inserting two items below threshold


### phantom pattern {#phantom-pattern}

-   read/modify/write
-   doctor example can lock rows
-   other examples can't attach lock
-   write affect the query in another - phantom


### materializing phantoms {#materializing-phantoms}

-   meeting room
    -   create room-time-period rows


## Serializability {#serializability}


### single-thread execution {#single-thread-execution}


#### stored procedure {#stored-procedure}

-   send application code to make decisions, remove network hop
-   hard to debug and can hog DB


#### partitioning {#partitioning}

-   multi-partition transactions - hard


#### limitations {#limitations}

-   transactions must be small and fast, no long tail
-   active dataset must fit into memory
    -   use anti-caching, abort transaction, fetch data to memory
-   write throught could slow things down require partitioning
-   limit cross-partition transactions


## two-phase locking (2PL) {#two-phase-locking--2pl}

-   read lock in shared more
-   write exclusive lock
-   upgrade from shared to exclusive if r/w same object
-   hold lock until end of transaction


### Limitations {#limitations}

-   several transactions (even simple ones) will form queue
-   unstable latencies
    -   very slow at high percentiles
-   deadlocks


### predicate locks {#predicate-locks}

-   cannot have phantoms
    -   select \* from table where room=123 and start\_time > & end\_time <
    -   predicates lock on phantom rows which don't exist yet


### index-range locks {#index-range-locks}

-   have index on room\_id and index on start\_time and end\_time
    -   shared lock on room\_id index
    -   or shared lock on time range index
-   inserting update or deletion will have to update a locakable index


## Serializable Snapshot Isolation (SSI) {#serializable-snapshot-isolation--ssi}

-   optimistic concurrency control
-   detect isolation violation - abort and retry


### implementaion {#implementaion}

-   detect reads of a stale MVCC object
-   detect writes that affect prior reads


### detecting stale MVCC reads {#detecting-stale-mvcc-reads}

-   doctor example:
    -   A's update doctors on\_call affects B's reading of it
    -   B's reading on an ealier MVCC vs A's later txid


### detecting writes that affect prior reads {#detecting-writes-that-affect-prior-reads}

-   doctor example:
    -   A and B both read, but at different transactions, track this
    -   on a write, see affected reads


### performance {#performance}

-   trade-off in granularity of r/w tracking


## Summary {#summary}

Treatment of different isolation levels

-   read committed (no dirty reads and no dirty writes)
    -   only read what has been committed
    -   only overwrite what has been committed
        -   don't overwrite partial transactions
-   snapshot isolation
    -   prevent read skews
    -   read a consistent state of the DB
    -   good when have to read a bunch of things
    -   implemented with MVCC
-   write concurrency issues
    -   lost updates on read-modify-write cycle
        -   lock all relevant rows
    -   write skew also a read-modify-write but acting on different rows
    -   phantom reads
        -   cannot lock on non-existing rows
        -   materialize or index-range lock
-   serializable isolation (strongest)
    -   single thread execution
    -   two phase locking
    -   serializable snapshot isolation
        -   also use MVCC to detect isolation violations

-   serializable
