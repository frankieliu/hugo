+++
title = "Vector clocks"
author = ["adam"]
date = 2019-10-12T12:46:54-07:00
lastmod = 2019-10-12T15:32:26-07:00
tags = ["scalable", "vector-clocks", "concurrent-writes"]
categories = ["scalable"]
draft = false
weight = 2000
[menu.main]
  identifier = "vector-clocks"
  weight = 2000
+++

## vector clocks {#vector-clocks}

A, B, C, D are trying to set a date.

-   Alice starts off
    (Wed, (A:1))
-   (Tue, (A:1,B:1))
-   (Tue, (A:1,B:1,D:1))
-   (Thu, (A:1,C:1))   -> Conflict

(A:1,C:1) did not descencd from (A:1,B:1,D:1)


### Descend {#descend}

Each marker in vclk2 must have corresponding or greater marker than in vclk1


### Resolve {#resolve}

(Thu, (A:1, B:1, C:1, D:2))


## problems {#problems}

width of vector clock grows with number of actors, or clients.

-   keep growth under control with timestamp to prune old clocks


## revisited {#revisited}


### Actor {#actor}

Some entity in the system that makes an update to an object

-   unit of concurrency
-   examples: server, client, virtual node, process, thread


### Updates {#updates}

When an actor updates a key it will increment its own entry in the vector.


### Example {#example}

VersionVectorA = [(a,3),(b,2),(c,1)]

-   Actor a has issued 3 updates, b 2 updates, etc


### History {#history}

A = [(a,2),(b,2),(c,1)]
B = [(a,3),(b,2),(c,1)]
B > A   : B dominates A
B >= A  : B descends A

A = [(a,1)]
B = [(b,1)]
A and B are concurrent


### Merging {#merging}

AB = [(a,1),(b,1)]


## problems {#problems}

-   actor explosion (as explained before)
-   client enforcing DB invariants


## Read your own writes {#read-your-own-writes}

For a client to issue a strictly increasing order of events, it must
know the last event it issued.  To guarantee that a client will read its last
write, it must issue writes to W primary relicas and read from R primary
replicas such that W+R > N (N: number of replicas)


### History repeating {#history-repeating}

C: Client

c gets value and version vector for key
c sends put with value and clientID and vv
at each of N V Nodes:

-   read local value from disk
-   if local vv > incoming vv ignore write
-   if incoming vv > local, overwrite
-   if incoming vv ~ local, add new value as sibling

if c doesn't get a correct value, then update doesn't go through
Example:
local vv has [(x,1)]
c doesn't get a correct read assumes [(x,0)]
incoming vv has [(x,1)]

since local vv > incoming vv don't do anything -> data is lost


## Vnode Version Vectors {#vnode-version-vectors}

let vnodes be actors in the system, since a vnode is a unit of concurrency
Cx and Cy read "Rita" [(a,1)] from Vnode a
Cx puts "Bob"
Cy puts "Sue"
vnode can update to "Bob" [(a,2)]
what should it do to "Sue"?

If you update to "Sue" [(a,2)] then it will overwrite the fact that
both are concurrent, so the Version Vector algo:

if local vv descends incoming vv, add new value as sibling:

"Bob", "Sue" [(a,2)]


## Downside {#downside}

Vnode Version Vectors love idempotent PUTs

With original vv:

Cx puts with vv [(x,2),(y,2)], db fails to answer,
but store the write, reissuing the same write will be idempotent.

With Vnode Version Vectors
re-issuing write generates a sibling with identical value (use set)


### coordinating vnode {#coordinating-vnode}

there must be a coordinating vode (from preference list) that coordinates the
PUT.  If a node receiving the request is not on the pref list, the request must
be forward to a node that is, adds latency to a PUTs


### sibling explosing {#sibling-explosing}
