+++
title = "Craq - Terrace and Freedman"
author = ["adam"]
date = 2020-02-07T08:23:32-08:00
lastmod = 2020-02-07T08:40:13-08:00
tags = ["zookeeper", "object store", "chain replication"]
categories = ["zookeeper", "object store"]
draft = false
weight = 2000
foo = "bar"
baz = "zoo"
alpha = 1
beta = "two words"
gamma = 10
mathjax = true
+++

## questions {#questions}

-   what is the interface provided
    -   simple k,v store


## what are the guarantees discussed {#what-are-the-guarantees-discussed}

-   strong and eventual consistency


## chain replication {#chain-replication}

-   where are requests handled?
    -   write at head
    -   read at tail
-   what is the dotted line going back from tail to head
    -   reply to the "write" client - committed
-   why is this cheaper than other topologies
    -   because of pipelining of the writes down the chain
-   what consistency does CR achieve?
    -   strong consistency
-   at what cost?
    -   read throughpout


## apportioned queries {#apportioned-queries}

-   explain dirty and clean
    -   after writing before receiving acknowledgement it is dirty
-   what happens to a node on a dirty rad
    -   tail asks the tail's last committed version number, then
        it returns that version of the object
-   explains why this is still satisfying strong consistency
    -   reads are serialized wrt tail
    -   i.e. only returning a read that has already been committed
-   how does node know if clean or dirty without a flag
    -   if it has two versions of the data it is dirty
    -   deletes old version when received an acknowledgement

{{< figure src="/images/craq/craq-fig3.png" >}}
