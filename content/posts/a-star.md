+++
title = "A-star"
author = ["adam"]
date = 2020-04-21T19:15:00-07:00
lastmod = 2020-04-22T15:53:35-07:00
tags = ["a-star", "search"]
categories = ["a-star", "search"]
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

## Heuristic paper {#heuristic-paper}

"A Formal Basis for the Heuristic Determination of Minimum Cost Paths", Peter E.
Hart, Nils J. Nilsson, and Bertram Raphael.


## Definitions {#definitions}

For any subgraph \\(G\_s\\) and any goal set \\(T\\) and starting state \\(s\\):

Let \\(f^\*(n)\\) be the actual cost of an optimal path constrained through \\(n\\), from
\\(s\\) to \\(n\\) to a preferred goal node \\(n\\).

From this definition, the ('unconstrained') optimal path can be written as
\\(f^\*(s) = h^\*(s)\\), where \\(h^\*(n)\\) is the optimal path from node \\(n\\) to the
preferred goal node of \\(s\\).

If \\(n\\) is in the optimal path, then \\(f^\*(n) = f^\*(s)\\).

In particular, \\(f^\*(n') > f^\*(s)\\) for every node \\(n'\\) not on the optimal path.

In addition we will also define a \\(g^\*(n)\\) as the optimal cost path from \\(s\\) to
\\(n\\).  Thus \\(f^\*(n)\\) can be divided into two terms:

\\(f^\*(n) = g^\*(n) + h^\*(n)\\)

{{< figure src="/images/astar/optimal-path.svg" >}}


## Heuristics and best cost so far {#heuristics-and-best-cost-so-far}

A heuristic algorithm can estimate all of these costs, let \\(f,g,h\\) be estimates
for the corresponding optimal costs \\(f^\*,g^\*,h^\*\\). In particular,

\\(g(n) \ge g^\*(n)\\)

The estimate \\(g(n)\\) is the estimate of the cost from \\(s\\) to
\\(n\\).  As the graph is traversed by the algorithm, this estimate
may change.  It is the same cost that would be found in Dijkstra's.
So think of \\(g(n)\\) as the "best cost so far" to node \\(n\\).

\\(h(n)\\) is the estimated cost from \\(n\\) to a preferred target node. It is an
estimate from a heuristic that we apply to the problem. For example one might
estimate the trip distance between SF and NY to be the straight line distance on
a map, whereas the optimal distance via driving by car will most likely be
longer.

\\(f(n)\\) is the estimate for the whole constrained path from \\(s\\) through \\(n\\) to
preferred target node from \\(n\\).  It is made up of two parts, both estimates:

\\(f(n) = g(n) + h(n)\\)

the estimate of the best cost so far to a node \\(n\\), and the heuristic cost for
the rest of the trip from that node \\(n\\) to its preferred target node.

I have been referring to the preferred target node because the goal set \\(T\\)
could be contain various desirable end goal states, for example winning
positions in a chess game.


## Graph search algorithm {#graph-search-algorithm}

Typically we select a node from the frontier nodes which has the best cost
estimate so far, picked from a priority queue or heap.

This node is then expanded, i.e. we look at the possible actions from this node,
and update previously encountered nodes or generate new nodes depending on the
whether this node touches other nodes in the frontier or adds new nodes to the
frontier.

The expanded node then becomes part of the explored set (or closed set) and any
nodes that were created become part of the frontier set.

{{< figure src="/images/astar/frontier.svg" >}}


## Admissible {#admissible}

Next we will be talking about two conditions on \\(h\\) that are required so that
the algorithm finds an optimal solution.

If the graph is a tree, then it is sufficient that our guess \\(h\\) have an
admissable heuristic:

\\(h(n) \le h^\*(n)\\)

We will skip the proof for now and just provide some intuition.

If \\(n\\) is in the optimal path, and if \\(h\\) is admissable then it is guaranteed
that \\(n\\) will be picked from the priority queue prior to getting to the target.

This is because the estimated cost at \\(n\\), i.e. \\(f(n)=g(n)+h(n)\\), will be
smaller than the optimal cost by the admissability condition. Note that \\(g(n)\\)
in a tree is always \\(g^\*(n)\\) (there is only one way to arrive at node \\(n\\)) and
since \\(f^\*(n) = g^\*(n) + h^\*(n)\\), \\(f(n) \le f^\*(n) = f(s)\\) (since \\(n\\) is in
the optimal path).

The proof is very similar. Basically assume that a node \\(n\\) in the optimal path
was not chosen, then you arrive at a contradiction because \\(f(n) \le f(s)\\), so
node \\(n\\) must be chosen prior to arriving at the target.


## Consistency {#consistency}

Admissibility, however, is not sufficient in a graph, because there may be other
non-optimal paths to the target that have a lower cost than \\(f(n)\\) for a node
\\(n\\) in the optimal path.

{{< figure src="/images/astar/admissible.svg" >}}

In the example above, we would have expanded node \\(b\\) since \\(f(b) = 100+1\\)
whereas \\(f( c) = 1+1000\\).  Thus removing node \\(b\\) from the open set, and
blocking node \\(c\\) from reaching the target.

What is required here is a stronger condition, called consistency: for every
successor of \\(n\\), call it \\(n'\\), the following must hold

\\(h(n) \le h(n') + h^\*(n,n')\\)

In other words, the estimate \\(h\\) must be monotonically decreasing according to
the path cost from \\(t\\) to \\(s\\), so in the case above, \\(h( c)\\) must be less than
\\(h(b) - 1\\), this would have changed the relative positions of \\(f( c)\\) and \\(f(b)\\)
in the priority queue.

Without going into the proof, we build some intuition here by saying that we
must ensure that a predecessor's nodes estimate must not accumulate more cost
than that afforded by the optimal path between two nodes.

If we do that, then we can ensure that if there is a node \\(n\\) in the optimal
path it will be picked in the correct order since a successor of node \\(n\\), \\(n'\\)
will necessarily have higher \\(f(n') \ge f(n)\\): since \\(n'\\) is a successor node
\\(g^\*(n') > g^\*(n)\\), and in particular \\(g^\*(n') = g^\*(n) + h^\*(n,n')\\).  Adding
\\(h(n')\\) to both sides and taking the consistency condition, \\(f(n') > f(n)\\).

The proof goes pretty much along the same lines, via a contradiction.  Assume
that a node in the optimal path \\(n'\\) was expanded by the algorithm before a
predecessor node in the optimal path \\(n\\) was expanded, thus creating a blockage.
Since \\(n'\\) is expanded in some non-optimal way \\(g(n') > g^\*(n')\\).  For the
optimum path node we know that \\(g(n) = g^\*(n)\\),

\begin{eqnarray}
f(n') &=& g(n') + h(n') \\\\\\
      &>& g^\*(n') + h(n') \\\\\\
      &>& g^\*(n) + h^\*(n,n') + h(n') \\\\\\
      &>& g^\*(n) + h(n) \\\\\\
      &>& g(n) + h(n) \\\\\\
      &>& f(n)
\end{eqnarray}

Since \\(f(n')>f(n)\\), it is a contradiciton that \\(n'\\) was chosen before node \\(n\\).


## On branching calculations {#on-branching-calculations}

This is an aside on calculating the branching factor, which is useful in
determining whether a particular heuristic is better than another.

\\(N + 1 = 1+b+b^2+\cdots+b^d\\)

\\(N\\) is the number of nodes generated by A-star and \\(d\\) is the depth of optimal
path from \\(s\\) to \\(t\\). Then \\(b\\), the branching factor can be estimated from the
above,

\\(b^{d+1} - (N+1)b + N = 0\\)

There is a trivial solution \\(b=1\\), so in using a method like Newton's method
to solve the above equation begin with a initial solution bigger than \\(1\\) like
\\(10\\).

\begin{eqnarray}
x\_n &=& 10\\\\\\
x\_{n+1} &=& x\_n - \frac{f(x\_n)}{f'(x\_n)}
\end{eqnarray}
