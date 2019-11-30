+++
title = "Klepmann Chapter 9 Consistency and Consensus"
author = ["adam"]
date = 2019-11-02T12:05:45-07:00
lastmod = 2019-11-30T10:28:49-08:00
tags = ["klepmann", "scalable", "consistency", "consensus"]
categories = ["scalable"]
draft = false
weight = 2000
foo = "bar"
baz = "zoo"
alpha = 1
beta = "two words"
gamma = 10
mathjax = true
+++

## Consistency Guarantees {#consistency-guarantees}


### eventual consistency {#eventual-consistency}

-   eventually data converges


### different than transaction isolation {#different-than-transaction-isolation}

-   isolation - avoid race conditions due to concurrent execution
-   consistency - about coordinating replica state


### levels {#levels}

-   strongest - linearizability
-   causality and total ordering
-   commit in a distributed system
-   consensus problem


## Linearizability {#linearizability}

-   one replica illusion (one copy of the data)
-   guarantee read is most recent - recency guarantee
-   read A / write C / read A ok
-   read A / begin write C / read B / end write C / read A  not ok
    read is concurrent with the write
    -   linearizability, 1 always follows 1 (no flipping)
-   cas(x, vold, vnew)


## vs Serializability {#vs-serializability}

-   serializability is about transactions guaranteeing a sequential order
-   linearizability is about recency guarantees on read and write


## importance {#importance}


### locking and leader election {#locking-and-leader-election}

-   lock must be linearizable all nodes must agree on who holds the lock
    -   zookeeper - used for distributed locking and leader election


### constraints and uniqueness guarantees {#constraints-and-uniqueness-guarantees}

-   enforcing uniquess (username, filename)
    -   similar to acquiring a lock
    -   similar to cas operation
-   constraints that bank balance >= 0
    -   two people don't book the same flight
    -   requires a single up-to-date value for account balance or seat occupancy
-   uniquess constraints in DBs are linearizable
-   foreigh key and attribute constraints can be implemented without
    linearizability


### cross-channel timing dependencies {#cross-channel-timing-dependencies}

File storage service is not linearizable, that is two requests went into it,
one to store the image, and the other to resize the image.  What happened was
a race condition, resizer went first, and storage finished later.

If there is only one copy of the image, linearizability solves this problem,
why?  Because you can't resize something that hasn't been stored yet.  We
could enforce reading after write guarantees, until the write is committed
then we can do an image resize.

Think: simple copy of the data, and atomic operations.


## Implementing linearizable systems {#implementing-linearizable-systems}

-   sure you can solve with only one copy
-   fault tolerance requires multiple copies
-   single-leader (potentially linearizable)
    -   when leader fails
-   consensus algorithms (linearizable)
    -   prevent split brain and stale replicas
-   multi-leader replication (not linearizable)
    -   concurrent processes write on multiple nodes
    -   asynchronoously replications implies conflicting writes
-   leaderless replications (probably not linearizable)
    -   quorum reads and writes - only strict quorum
    -   LWW not linearizable
    -   sloppy quorum not linearizable


### linearizability and quorums {#linearizability-and-quorums}

-   strict quorum seems to solve the problem
-   weak quorum (lww) not good
    -   read A : 1(new) ReplicaA, 0(old) ReplicaB  -> got new value
    -   read B : 0(old) ReplicaB, 0(old) ReplicaC  -> got old value
-   make it stronger:
    -   possible for Dynamo-style quorums to be linearizable
        -   reader must perform read repair synchronously
        -   writer must read the latest state before sending its writes
-   only linearizble read and write operations can be implemented
    this way, a CAS operation cannot require consensus, read
    wait-free-sync paper


### cost of linearizability {#cost-of-linearizability}

-   network outage
    -   replicas cannot connect therefore they must become unavailable (C)
    -   if replicas remain available, then become non-linearizable (A)
    -   network partitioning (P in CAP), means you choose C or A


### linearizability and network delays {#linearizability-and-network-delays}

-   CPU/cache non-linearizable (two copies)
-   response time of read and write is proportional to uncertainty
    of network delay


## Ordering guarantees {#ordering-guarantees}


### ideas of order {#ideas-of-order}

-   order of writes in a replication log
-   serializability
    -   appearance that transactions executed in some sequential order
    -   allow concurrent operation prevent conflicts with either locks or aborts
-   timestamp in distributed systems
-   what is the connection between ordering, linearizability and consensus?


### order and causality {#order-and-causality}


#### why important (340) {#why-important--340}

-   consistent prefix (snapshot isolation)
-   causality multiple writes to replicas (multileader replication)
    -   network delay may reorder the writes
    -   in some replicas, a row may be updated before being created
-   two operations A,B
    -   either A happened before B
    -   B happened before A
    -   A and B are concurrent (no causal link)
-   read skew in bank account
    -   transaction must read from a consistent snapshot, ie
        -   must be consistent with causality, i.e. if you read an answer there
            must have been question
        -   read skew means you are not reading from one snapshot in time
-   write skew and phantoms, on-call example
    -   recap dirty writes and lost updates
        -   overwriting uncommitted data
            example car sale:
            -   writing to listing db alice/bob order, bob overwrites alice, bob gets
                the car
            -   writing to invoice db bob/alice order, alice overwrites bob, alice pays
                for the car
        -   read committed (no dirty reads, no dirty writes)
            -   does not prevent race conditions (also a lost update problem)
                counter example:
                -   A reads counter @ 42
                -   B reads counter @ 42
                -   A writes counter @ 43
                -   B writes counter @ 43
    -   recap write skew, doctor example
        -   both doctors check number of on-call doctors (count on all rows)
            -   alice updates her row
            -   bob updates his row
            -   generalization of the lost update problem
            -   in this case the update is on different records
                -   if the update is on the same record then it is a dirty write or lost
                    update
    -   phantom is similar to write skew problem
        -   read some condition (room has been booked or not, username)
        -   two people go ahead and book a room
        -   condition has changed
        -   difference here is that the condition is the absence of something
            (phantom)
    -   serializable snapshot isolation (ssi) detects write skews by detecting
        causal dependencies between transactions
-   cross channel timing, bob hear alice football or image file server
-   causality imposes an ordering on events
-   causally consistent means that system obeys causality order


### causal vs total order {#causal-vs-total-order}

-   linearizability
    -   total order of operations, single copy, every operation is atomic,
        any two operations have an order
    -   there are no concurrent operations in a linearizable datastore
-   causality
    -   two events may be concurrent, if two events are ordered if they are
        causally related, and they are incomparable if they are concurrent
-   linearizability implies causal order
-   causal consistency is the strongest possible consistency model that
    does not slow down due to network delay, and remain available in face
    of network failures (342)


### causal consistency {#causal-consistency}

-   need to know what happened before relationships
-   used some generalized vector versioning
    -   impractical can't keep track of everything that is read


## Lamport timestamps {#lamport-timestamps}

-   (counter, nodeID)
-   every node
    -   keeps track of the maximum counter it has seen so far and
        includes that maximum on every request
    -   increases its own counter to the max
-   does not solve things when they are needed
    -   username example:
        -   if two users ask for a username
        -   they both will have a unique Lamport timestamp
            -   but you can't resolve it until all other nodes are checked
            -   you need to know that the order is finalized


## total order broadcast {#total-order-broadcast}

-   requires to safety guarantees
    -   reliable delivery - no message is lost
    -   total order delivery - all messages are delivered in the same order to all
        nodes
-   zookeeper and etcd implement total order broadcast
    -   there is a strong connection between total order broadcast and consensus
-   state-machine replication
    -   if every replication processes the same writes in the same order, then the
        replicas will remain consistent with each other
-   total order
    -   order is fixed at the time the messages are **delivered**
    -   way of creating a log, delivering a message is like appending to the log
        -   all nodes must deliver the same message in the same order
-   fencing tokens
    -   lock is determined by message order


## linearizable vs total order {#linearizable-vs-total-order}

-   total order broadcast
    -   asynchronous
        -   msgs guaranteed to be delivered reliably in fixed order
        -   no guarantee when message will be delivered
-   linearizability
    -   recency guarantee
        -   a read is guaranteed to see the latest value written
-   x footnote:
    -   linearizable rw register is an easier problem
    -   total order broadcast has no deterministic solution in the asynchronous
        crash and stop model
    -   klepmann not very clear here, [67,68,23,24,25]
-   username example : total order + linearizable storage
    -   CAS on a register for a user name
    -   total order broadcast as an append-only log
        -   append msg with desired user name
        -   read the log, wait for msg delivery
        -   check any messages claiming username
    -   log entries delivered in the same order to all nodes
        -   nodes can agree which came first
    -   this method ensures linearizable write but not **reads**
        -   the read will have sequential consistency (timeline consistency)
            but it won't have recency guarantee
    -   alternatives to linearizable reads
        -   sequence the reads by appending to the log
        -   log allows fetching the position of the latest log
        -   read from a replica that is synchronously updated on writes
-   how to get total order broadcast from linearizable storage
    -   for every message you get from a linearizable register
    -   how is this different from Lamport time stamp?
        -   the sequence numbers have no gaps
        -   node delivered 4, and received a 6, must wait for 5 before delivering 6
-   linearizable compare and set register and total order broadcast are equivalent
    to consensus


## Consensus intro {#consensus-intro}

-   getting several nodes to agree on something
    -   build up: replication, transactions, linearizability, total order broadcast,
        consensus
-   use case:
    -   leader election
        -   leadership position might be contested in case of network failure
            -   cannot have two leaders - both would accept writes and data would
                diverge
            -   nodes must agree on who is the leader
    -   atomic commit
        -   all nodes must agree on the outcome of the transaction all or nothing
-   impossibility of consensus - FLP result
    -   not in practice, because systems can have timeouts


## Atomic commit and two phase commit {#atomic-commit-and-two-phase-commit}

-   single node
    -   commit depends on the order in which data is durably written to disk
-   multi-node cases
    -   multi-object transaction in a partitioned db
    -   term-partitioned secondary index
-   cannot allow individual node to commit because some may abort
    -   necessary for read committed isolation
-   how is this different from two phase locking?
    -   2PL provides serializable isolation
        -   prevents dirty writes, write skew, and lost updates
    -   2PC provides atomic commit in a distributed database


### implementation {#implementation}

-   coordinator (transaction manager)
-   participants
    -   application rw on multiple db nodes
-   application
    -   application requests a transaction ID from coordinator
    -   begins single-node transactions on each of the participants
    -   when ready to commit coordinator begins phase 1
-   phase 1:
    -   coordinator sends a prepare to each node
        -   asking them whether they are able to commit
    -   if all participants reply "yes" (promise to can commit)
        -   coordinator goes to phase 2 (commit point, promise to finish it)
        -   else coordinator sends abort to all nodes
-   phase 2:
    -   participants wait to hear back from coordinator
        -   must wait for the coordinator to come back up
            -   commit point of 2PC comes down to a single-node atomic commit on the
                coordinator


### 3PC {#3pc}

-   2PC can become blocked waiting for coordinator to recover
    -   participants 'in doubt' or 'uncertain'
-   3PC relies on network with bounded delay and nodes with bounded response times
    -   non-blocking atomic commit requires a perfect failure detector


## Heterogeneous distributed transactions {#heterogeneous-distributed-transactions}

-   different technologies
-   use message queue
    -   msg can be ack as processed iff db transaction for processing the msg was
        successfully committed
    -   implemented by atomically committing the message ack and the db write in a
        single transaction
-   if msg broker or db transaction fails, both are aborted
    -   ensure that message is effectively processed exactly once


## Extended architecture (XA) {#extended-architecture--xa}

-   typically the coordinator is a library that is loaded on the same process as
    the application issuing the transaction
    -   keeps track of participants
    -   collects responses
    -   uses log in local disk to keep track of commit/abort decision
-   why is bad to be stuck 'in doubt' state?
    -   db have rows locked and cannot release the locks until the transaction
        commits or is aborted
-   limitations
    -   coordinator if single-node is a point of failure
    -   coordinator becomes stateful, application servers are no longer stateless


## Consensus {#consensus}
