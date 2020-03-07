+++
title = "Facebook - memcached"
author = ["adam"]
date = 2020-03-07T07:47:47-08:00
lastmod = 2020-03-07T08:29:58-08:00
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

Q: what is a wide fanout


## Multiple FE clusters {#multiple-fe-clusters}

-   single geo region
-   control data replication
-   data consistency


## Multiple regions {#multiple-regions}

-   muliple geo regions
-   storage replication
-   data consistency


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
