+++
title = "Flink"
author = ["adam"]
date = 2020-04-18T08:49:58-07:00
lastmod = 2020-04-18T10:37:08-07:00
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


## Stale synchronous parallel {#stale-synchronous-parallel}

{{< figure src="/images/flink/ssp.png" >}}

-   workers at clock \\(c\\) can see updates at \\([0,c-s-1]\\)
-   here \\(c\\) counts the iterations in some algorithm, not wall clock time
-   \\(s\\) is a bound for staleness, guarantee that all workers at at most
    \\(s\\) cycles away from each other
-   workers can always see their own updates \\([0,c-1]\\)
-   workers may see some updates from other workers \\([c-s,c+s-1]\\)
