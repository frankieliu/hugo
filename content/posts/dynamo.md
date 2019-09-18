+++
title = "DynamoDB"
author = ["adam"]
date = 2019-09-15T15:25:05-07:00
lastmod = 2019-09-17T15:23:30-07:00
tags = ["dynamo", "db", "amazon", "scalable"]
categories = ["scalable"]
draft = false
weight = 2003
foo = "bar"
baz = "zoo"
alpha = 1
beta = "two words"
gamma = 10
mathjax = true
[menu.main]
  identifier = "dynamodb"
  weight = 2003
+++

## Highlights {#highlights}

1.  kv store
2.  data partitioning and replication by consistent hashing
3.  consistency facilitated by object versioning
4.  consistency among replicas during update by quorum
5.  decentralized replica synchronization
6.  gossip based distributed failure detection and membership


## Background {#background}

-   Authors confuse 'C' in ACID with 'C' in CAP


### 2.3 {#2-dot-3}

-   optimistic replication - conflict resolution when you need item
-   allow writes/updates - "always writable"
-   pushes complex conflict resolution on the reader
    -   at data store means "last write wins"
    -   too simple, allow client to do the conflict resolution


## Related work {#related-work}

1.  "always writable" requirement
2.  trusted nodes
3.  simple k-v
4.  latency ~ 100-200ms
    -   zero-hop DHT, each node can route request to appropriate node

{{< figure src="/images/dynamo/dynamo-table-1.png" >}}


## System architecture {#system-architecture}

-   components:
    -   data persistence component
    -   load balancing
    -   membership
    -   failure detection
    -   failure recovery
    -   replica synchronization
    -   overload handling
    -   state transfer
    -   concurrency
    -   job scheduling
    -   request marshalling
    -   request routing
    -   system monitoring
    -   system alarming
    -   configuration management
-   cover:
    -   partitioning
    -   replication
    -   versioning
    -   membership
    -   failure handling
    -   scaling


### system interface {#system-interface}

1.  api get and put
2.  get(key)
    1.  locates object replicas
    2.  returns with conflicting versions
    3.  returns with a context
3.  put(key, context, object)
    1.  determines which replica
    2.  context : metadata such as version
4.  key and object are opaque array of bytes
    1.  use MD5 hash to generate a 128-bit id


### partitioning {#partitioning}

1.  consistent hashing
2.  each node assigned a random position in the ring
3.  each data item hashed to ring and served by first node larger position
4.  each node serves data between it and its predecessor
5.  each node actually mapped to multiple points in the ring (tokens)
6.  virtual node advantages
    1.  if node goes down, load gets handled more evenly by other nodes


### replication {#replication}

1.  data item is replicated at \\(N\\) hosts
2.  each key assigned to a coordinator node
3.  coordinator is in charge of replication of the data items that fall in its
    range
4.  coordinator replicates key at N-1 clockwise successor nodes in the ring
    1.  each node is responsible for between it and its \\(N\\) th predecessor
5.  preference list is the list of nodes responsible for a key
6.  every node in the system can determine which nodes for a key
7.  the pref list skips positions in the ring to ensure that it contains only
    distinct physical nodes


### data versioning {#data-versioning}

1.  eventual consistency, data propagates asynchronously
2.  guarantees that writes cannot be forgotten or rejected
    1.  each modificaiton is a new and immutable version of the data
3.  version branching can happen in the presence of failures
    resulting in conflicting versions, client must perform
    reconciliation
4.  vector clocks used to capture causality
    1.  (node, counter)
    2.  if the counters of an object are less-than-or-equal to all the
        nodes in a second clock, the first is an ancestor
5.  on update, client must specify which version is being updated
    1.  pass the context from earlier read

{{< figure src="/images/dynamo/vector-clock.png" >}}

1.  timestamp is used to truncate the clock which may be growing


### get and put operations {#get-and-put-operations}

1.  route request through LB
2.  use partition aware client library that routes to coordinator
3.  requests received through a LB routed to any random node in ring
    1.  node will forward to the first among top \\(N\\) in preference list
4.  quorum protocol \\(R+W > N\\)
5.  put(), coordinator generates vector clock for new version
    1.  sends to \\(N\\) highest-ranked reachable nodes
    2.  if \\(W-1\\) nodes respond then the write is considered successful
6.  get(), coordinator requests all existing versions of data forward
    for that key, wiates for \\(R\\) responses before returning value to
    client


### handling failure {#handling-failure}

-   hinted handoff

    -   loose quorum membership "sloppy quorum" : first \\(N\\) healthy
        nodes from preference list

    {{< figure src="/images/dynamo/consistent-hashing.svg" >}}

-   anti-entropy, replica synchronization protocol
-   merkle tree
    -   each branch can be checked independently without checking entire
        tree
    -   each node maintains a separate merkle tree for each key range
    -   two nodes exchange the root of the merkle tree for key range


### membership and failure detection {#membership-and-failure-detection}

-   gossip based protocol propagates membership changes
-   maintains an eventually consistent view of membership
-   each node contacts a peer chosen at random every second
    -   two nodes reconcile their persisteted membership change
        histories
-   nodes choose set of tokens (virtual nodes in the consistent
    hash space) and maps nodes to their respective token sets
-   mapping persisted on disk, contains local node and token set
-   mappings reconciled via gossip


#### seeds {#seeds}

-   special nodes known to all nodes
-   seeds obtained through static config or config service
-   all nodes must reconcile at seeds, logical partitions unlikely


#### failure detection {#failure-detection}

-   local notion of failure, if node A can't communicate with B, then
    uses alternate nodes
-   decentralized failure detection use simple gossip-style protocol


### adding and removing storage nodes {#adding-and-removing-storage-nodes}

-   transfer keys to new node
-   reallocation of keys upon removal


## Conclusions {#conclusions}

-   not very useful
