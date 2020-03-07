+++
title = "Facebook - memcached"
author = ["adam"]
date = 2020-03-07T07:47:47-08:00
lastmod = 2020-03-07T09:50:23-08:00
tags = ["facebook", "memcached", "distributed systems"]
categories = ["distributed systems"]
draft = false
weight = 2000
foo = "bar"
baz = "zoo"
alpha = 1
beta = "two words"
gamma = 10
mathjax = true
toc = true
+++

## Front-end cluster {#front-end-cluster}

{{< figure src="/images/facebook/front-end-cluster.png" >}}

-   read heavy workload (100:1 R/W)
-   wide fanout
-   handle failures
-   10 Mops/s

Q: what is a wide fanout


## Multiple FE clusters {#multiple-fe-clusters}

-   single geo region
-   control data replication
-   data consistency
-   100 Mops/s


## Multiple regions {#multiple-regions}

-   muliple geo regions
-   storage replication
-   data consistency
-   1 Bops/s


## Pre-memcached {#pre-memcached}

{{< figure src="/images/facebook/pre-memcached.png" >}}


## High fanout {#high-fanout}

{{< figure src="/images/facebook/high-fanout.png" >}}

-   data dependency graph for a small user request


## Look-aside cache {#look-aside-cache}

![](/images/facebook/look-aside-cache.png)
![](/images/facebook/look-aside-cache-update.png)

-   why deletes over set
    -   idempotent
    -   demand filled

-   webserver specifie which keys to invalidate after DB update


## Invalid sets {#invalid-sets}

{{< figure src="/images/facebook/invalid-sets.png" >}}

-   attach lease-id with every miss
-   lease-id invalidated on a delete
-   cannot set if lease-id is invalidated

Q: who sets the lease-id
Q: how do you invalidate someone else's lease-id
Q: how many do you order the lease-id

-   CAS : is this like load-link/store conditional
    -   CAS is weaker because it will write if value read is the same as last read
    -   LL/SC will not write if there has been an update
    -   tagged state reference (add a tag to indicate how many times modified)


## Thundering herds {#thundering-herds}

![](/images/facebook/thundering-herds-1.png)
![](/images/facebook/thundering-herds-2.png)

Q: how do you prevent thundering herds?

-   Memcache informs WS that it will be updated soon by some other WS
    -   WS can then wait for the update or use stale value


## All-to-all communication {#all-to-all-communication}

{{< figure src="/images/facebook/all-to-all.png" >}}

1.  Incast congestion
    -   amplification of data from memcached
    -   limit the number of outstanding requests

{{< figure src="/images/facebook/incast-congestion.png" >}}

1.  Limits horizontal scalability
    -   multiple memcached clusters "front" one DB
    -   consistency
    -   over-replication

{{< figure src="/images/facebook/multiple-clusters.png" >}}


## DB cache invalidation {#db-cache-invalidation}

{{< figure src="/images/facebook/mcsqueal.png" >}}

1.  Cached data invalidated after DB updates
2.  Issue deletes from commit log

Q: MC still serving stale data?  Why not invalidate pre-emptively?

1.  Too many packets
    a. intra-cluster BW > inter-cluster BW
    b. aggregation reduces packet rate by 18x
    c. easier configuration management, each layer just needs to know next
    d. each stage can buffer deletes in case of downstream components

{{< figure src="/images/facebook/memcache-routers.png" >}}


## Geo distributed clusters {#geo-distributed-clusters}

![](/images/facebook/multi-region-race.png)
![](/images/facebook/update-marker.png)


## Lessons {#lessons}

1.  push complexity to the client
    -   there are no server to server communication
2.  operation efficiency is as important
    -   routing pipeline
    -   slower
    -   configuration tight and local
3.  separate cache and persistance separate


## Q&A {#q-and-a}

1.  bottle neck single memcache
    -   tail of memcache provision for the tail
2.  memcache flash
3.  have a fast in-memory
    -   fetch a lot of data
    -   small data problem - not a big data problem
4.  size of cache/average utilization
    -   different pools
    -   cache just store the hot heads
