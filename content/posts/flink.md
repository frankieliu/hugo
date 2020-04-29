+++
title = "Flink"
author = ["adam"]
date = 2020-04-18T08:49:58-07:00
lastmod = 2020-04-25T11:29:15-07:00
tags = ["stream", "distributed systems"]
categories = ["stream", "distributed systems"]
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

## What is it {#what-is-it}

-   a distributed runtime
-   uses pipelines for execution
-   exactly-once state consistency
-   lightweight checkpoint
-   iterative processing
-   windows semantics
-   out-of-order processing


## 2 architecture {#2-architecture}


### cluster {#cluster}

-   client
-   job manager
-   task manager (1 or more)


### client {#client}

-   takes a program
-   xforms to dataflow graph
-   submits to job manager
-   creates data schema and serializers
-   cost-based query optmization


### job manager {#job-manager}

-   coordinates distributed execution of dataflow
-   tracks state and progress of each operator and stream
-   schedules new operators
-   coordinates checkpoints and recovery
-   persists minimal set of data for checkpoint and recovery


### task manager {#task-manager}

-   executes one or more operators
-   report status to job manager
-   maintain buffer pools to buffer or materialize streams
-   maintain network connections to exchange of streams between operators

{{< figure src="/images/flink/process.png" >}}


## 3.1 dataflow graphs {#3-dot-1-dataflow-graphs}

-   stateful operators
-   data streams
-   data-parallel fashion
-   operators
    -parallelized into one or more parallel instances (subtasks)
-   stream split into one or more stream partitions


## 3.2 data exchange {#3-dot-2-data-exchange}


### Intermediate data streams {#intermediate-data-streams}

-   core abstraction for data-exchange between operators
-   represents a logical handle


### Pipelined streams {#pipelined-streams}

-   propagate back pressure from consumers to producers
    -   via intermediate buffer pools
    -   avoid materializatoin when possible


### Blocking streams {#blocking-streams}

-   buffers all the producing operators data before making
    available for consumers
-   used to isolate successive operators
    -   ex. sort-merge joins may cause distributed deadlock
        ![](/images/flink/sort-merge-join.png)
        ![](/images/flink/radix-hash-join.png)


### implementation {#implementation}

-   exchange of buffers
-   set high buffer size (1kB) for high throughput
-   set low timeout (2 ms) for low latency


### control {#control}

-   checkpoint barriers
-   watermark signals
-   iteration barriers
-   unary operators consule in FIFO order
-   more than one stream merge in arrival order
    -   Flink does not provide ordering guarantees after repartitioning
    -   let the operators figure out how to deal with out of order


## 3.3 fault tolerance {#3-dot-3-fault-tolerance}

-   promises exactly once processing consistency
-   uses checkpointing and partial re-execution
    -   data sources are persistent and replayable
-   take consistent snapshot of all operators
    -   must refer to same logical time in the computation
-   Asynchronous Barrier Snapshotting
    -   operator receives barriers from upstream
    -   perform alignment
        -   make sure barriers from all inputs have been received
    -   operator writes its state to persistent storage
    -   after backup, forwards the barrier

{{< figure src="/images/flink/abs.png" >}}

-   Example:
    snapshot t2 contains all operator states that are the result of consuming all
    records before t2 barrier.
-   don't need to snapshot in-flight records
-   restart from lastest barrier with a snapshot
-   guarantees:
    -   exactly once state updates
    -   decoupled from control
    -   decoupled from how it is stored


### Details {#details}

-   Paper: Lightweight Asynchronous Snapshots for Distributed Dataflows

-   Central coordinator periodically injects stage barriers
-   When source receives a barrier
    -   takes snapshot of its current state
    -   broadcasts the barrier to all its output

        {{< figure src="/images/flink/abs-1.png" >}}

-   When a non-source task receives a barrier
    -   blocks that input until it receives a barrier from all inputs

        {{< figure src="/images/flink/abs-2.png" >}}

    -   when all barriers have been received
        task takes snapshot of current state and broadcasts
        the barrier to its outputs

        {{< figure src="/images/flink/abs-3.png" >}}

    -   task unblocks its input channels to continue computation

        {{< figure src="/images/flink/abs-4.png" >}}

-   legend

    {{< figure src="/images/flink/abs-5.png" >}}

-   The complete global snapshot \\(G^\* = (T^\*, E^\*)\\) will contain only
    snapshots of the operator states, edge states don't need to be saved

-   Algorithm for non-cyclic graphs

    {{< figure src="/images/flink/abs-6.png" >}}


### cyclic graphs {#cyclic-graphs}

-   with cycles you will end up in a deadlock
    -   downstream tasks will be blocked because they
        have not received a barrier

-   records in transit in cycle would not be included
    in snapshot

-   first indentify:
    1.  back-edges
    2.  \\(G(T,E\\L)\\) remove them, now you have a DAG
    3.  backup records received from back-edges
        -   task \\(t\\) that has a back-edge: \\(L\_t \in I\_t\\)
        -   \\(I\_t\\) creates a backup log of all records received
            from \\(L\_t\\), when it forwards barriers until receiving
            the barrier back in \\(L\_t\\)

-   Tasks with back-edge inputs create a local copy of their
    state once all the regular (\\(e \notin L\\)) channels delivered
    barriers.

    ![](/images/flink/abs-7.png)
    ![](/images/flink/abs-8.png)

-   Allows all pre-shot recods that are in transit with loops
    to be included in the current snapshot

    {{< figure src="/images/flink/abs-9.png" >}}

    The final global snapshot will include the back-edge records
    in transit: \\(G^\* = (T^\*, L^\*)\\).

-   Algorithm

    {{< figure src="/images/flink/abs-10.png" >}}


## 3.4 iterative dataflows {#3-dot-4-iterative-dataflows}

{{< figure src="/images/flink/iteration-model.png" >}}

-   implemented as iteration steps
-   special operator that can contain an execution graph
-   to maintain DAG
    -   introduce an iteration head and tail tasks
        -   implicitly connected with feedback edges
    -   tasks establish active feedback channel
    -   provide coordination for processing data records


## time {#time}

-   event time
-   process time
-   low watermarks mark gloval progress measure
    -   time t such that all events lower than t have already entered operators
    -   allow processing in correct event order and serialize operations
    -   originate from the sources
    -   propagates to other operators
        -   map and filter just forward the watermarks
        -   complex operators compute events triggered by a watermark, then fwd
        -   if more than one input, only fwd the min of incoming watermarks
-   processing time used for lower latency
-   ingestion time: somewhere in between event time and processing time


## stateful stream {#stateful-stream}

-   windows are stateful operators
    -   fill memory buckets
-   operator annotation used to statically register explicit local variables
-   k-v states declared with an operator
-   registered state is durable with exactly-one update


## windows {#windows}

-   definition
    -   assigner: assign record to logical window
        -   a record can be assigned to multiple windows
            -   as in sliding window
    -   trigger: defines when the operation will be performed
    -   evictor: determines what to keep
-   types
    -   periodic time
    -   count windows
    -   punctuation
    -   landmark
    -   session
    -   delta


### Example {#example}

```java
stream
    .window(SlidingTimeWindows.of(Time.of(6, SECONDS), Time.of(2, SECONDS))
            .trigger(EventTimeTrigger.create())
```

-   assigner: range 6 seconds, every 2 seconds
-   trigger: results computed once the watermark passes the end of the window

<!--listend-->

```java
stream
    .window(GlobalWindow.create())
    .trigger(Count.of(1000))
    .evict(Count.of(100))
```

-   assigner: all events go to a single logical group
-   trigger: every 1000 events
-   evictor: keep only the last 100 elements


## async stream iteration {#async-stream-iteration}

feedback streams are treated as operator state


## Batch analytics {#batch-analytics}

-   query optimiztion
-   memory management
-   batch iterations


## Query optimization {#query-optimization}

-   optimizer doesn't know about UDF's
-   cardinality: uses hints from the programmer
-   plan uses costs like network disk I/O and CPU
-   strategies
    -   repartitioning
    -   broadcast data transfer
    -   sort based grouping
    -   sort based and hash based join


## Memory management {#memory-management}

-   manages data into memory segments
-   sorting and joining work on binary
-   off-heap and binary
    -   reduce gb
    -   cache efficient


## Iteration control {#iteration-control}

{{< figure src="/images/flink/iterate.png" >}}

```java
// set up execution environment
env = ExecutionEnvironment.getExecutionEnvironment();

// get input data:
// read the points and centroids from the provided paths
// or fall back to default data
points = getPointDataSet(params, env);
centroids = getCentroidDataSet(params, env);

// set number of bulk iterations for KMeans algorithm
loop = centroids.iterate(params.getInt("iterations", 10));

newCentroids = points
      // compute closest centroid for each point
      .map(new SelectNearestCenter()).withBroadcastSet(loop, "centroids")
      // count and sum point coordinates for each centroid
      .map(new CountAppender())
      .groupBy(0).reduce(new CentroidAccumulator())
      // compute new centroids from point counts and coordinate sums
      .map(new CentroidAverager());

// feed new centroids back into next iteration
finalCentroids = loop.closeWith(newCentroids);
```


### delta iterate {#delta-iterate}

![](/images/flink/delta.png)
![](/images/flink/connected-components.png)


### Bulk synchronous parallel {#bulk-synchronous-parallel}

-   concurrent computation
-   communication
-   barrier synchronization

{{< figure src="/images/flink/bsp.png" >}}

-   cost of BSP from wikipedia
    \\[\max\_i w\_i + \max\_i h\_ig + l\\]
    -   \\(w\_i\\) is the computation cost
    -   \\(h\_i\\) the number of messages
    -   \\(g\\) cost per message
    -   \\(l\\) barrier synchronization cost
-   this is for one superstep


### superstep synchronization {#superstep-synchronization}

[iterations](https://ci.apache.org/projects/flink/flink-docs-stable/dev/batch/iterations.html)
![](/images/flink/barrier-flink.png)


### Stale synchronous parallel {#stale-synchronous-parallel}

{{< figure src="/images/flink/ssp.png" >}}

-   workers at clock \\(c\\) can see updates at \\([0,c-s-1]\\)
-   here \\(c\\) counts the iterations in some algorithm, not wall clock time
-   \\(s\\) is a bound for staleness, guarantee that all workers at at most
    \\(s\\) cycles away from each other
-   workers can always see their own updates \\([0,c-1]\\)
-   workers may see some updates from other workers \\([c-s,c+s-1]\\)
