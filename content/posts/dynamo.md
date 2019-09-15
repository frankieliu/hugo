+++
title = "DynamoDB"
author = ["adam"]
date = 2019-09-15T15:25:05-07:00
lastmod = 2019-09-15T16:38:01-07:00
tags = ["dynamo", "db", "amazon", "scalable"]
categories = ["scalable"]
draft = false
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

-   Authors confuses 'C' in ACID with 'C' in CAP


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

{{< figure src="/ox-hugo/dynamo-table-1.png" >}}


## System architecture {#system-architecture}


## Conclusions {#conclusions}

-   not very useful
