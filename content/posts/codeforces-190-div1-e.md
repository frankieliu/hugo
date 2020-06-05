+++
title = "Codeforces-190-Div1-E Ciel and Gondolas"
author = ["adam"]
date = 2020-06-05T06:34:39-07:00
lastmod = 2020-06-05T06:54:35-07:00
tags = ["Ciel and Gondolas", "codeforces", "dp optimizations"]
categories = ["dp optimizations", "codeforces"]
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

## E. Ciel and Gondolas {#e-dot-ciel-and-gondolas}

Fox Ciel went into an amusement park. She is in line for the Ferris wheel. There
are \\(n\\) foxes in the queue. We will assume that the first fox is at the
beginning of the queue, and the \\(n\\) th fox is at the tail of the queue.

In total there are \\(k\\) gondolas.  We distribute foxes into gondolas as follows:

When the first gondola swims up, \\(q\_1\\) foxes enter from the front of the line into the
gondola.  Then, when the second gondola swims up, \\(q\_2\\) foxes from the
beginning of the remaining line go into this gondola.

...

The remaining \\(q\_k\\) foxes enter the last (\\(k\\) th) gondola.

Note that the numbers \\(q\_1 , q\_2 , \cdots, q\_k\\) must be positive.  From the condition
it follows that and \\(q\_i  > 0\\).

You know how foxes don't want to linger in gondolas with strangers. So, your
task is to find the optimal placement method (that is, determine the optimal
sequence \\(q\\)) to please everyone. For each pair of foxes \\(i\\) and \\(j\\), a value
\\(u\_{ij}\\) is given, which indicates the degree of unfamiliarity. You can assume
that \\(u\_{ij} = u\_{ji}\\) for all \\(i,j\\) (\\(1 \le i,j \le n\\)) and that
\\(u\_{ii} = 0\\) for all \\(i\\) (\\(1 \le i \le n\\)). Then the value of unfamiliarity
in the gondola is defined as the sum of the values ​​of unfamiliarity between all
pairs of foxes that are in this gondola. The total unfamiliarity value is
defined as the sum of unfamiliarity values ​​for all gondolas.

Help Fox Ciel find the minimum possible value for the total unfamiliarity with
some optimal distribution of foxes in the gondolas.


### Input data {#input-data}

The first line contains two integers \\(n\\) and \\(k\\) (\\(1 \le n \le 4000\\) and \\(1
\le k \le \min ( n , 800)\\) ) - the number of foxes in the queue and the number
of gondolas. The next \\(n\\) lines contain \\(n\\) integers each - the matrix \\(u\\), (
$0 &le; \\(u\_{ ij}  \le 9\\) , \\(u\_{ij}  =  u\_{ji}\\) and \\(u\_{ii}  = 0\\) ).

Please use quick read methods (for example, for Java use BufferedReader instead
of Scanner).


### Output {#output}

Print an integer - the minimum possible value of total unfamiliarity.


### Examples {#examples}


#### input data {#input-data}

```text
5 2
0 0 1 1 1
0 0 1 1 1
1 1 0 0 0
1 1 0 0 0
1 1 0 0 0
```


#### output {#output}

```text
0
```

input dataCopy
8 3
0 1 1 1 1 1 1 1
1 0 1 1 1 1 1 1
1 1 0 1 1 1 1 1
1 1 1 0 1 1 1 1
1 1 1 1 0 1 1 1
1 1 1 1 1 0 1 1
1 1 1 1 1 1 0 1
1 1 1 1 1 1 1 0
outputCopy
7
input dataCopy
3 2
0 2 0
2 0 3
0 3 0
outputCopy
2
Note
In the first example, you can distribute the fox like this: {1, 2} go to one gondola, {3, 4, 5} go to another gondola.

In the second example, the optimal distribution is: {1, 2, 3} | {4, 5, 6} | {7, 8}.
