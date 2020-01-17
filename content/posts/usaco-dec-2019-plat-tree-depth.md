+++
title = "Tree Depth - USACO Platimum Dec19"
author = ["adam"]
date = 2020-01-15T18:21:28-08:00
lastmod = 2020-01-16T22:42:38-08:00
tags = ["generating functions", "trees", "permutations"]
categories = ["usaco"]
draft = false
weight = 2000
foo = "bar"
baz = "zoo"
alpha = 1
beta = "two words"
gamma = 10
mathjax = true
+++

This is a commentary on the solution from Benjamin Qi.


## from permutation to tree generation {#from-permutation-to-tree-generation}

Before we go into the solution of this problem it is good to be able to
understand how to create trees using a permutation.

First how does a permutation \\(a\\) translate into a tree? Think of \\(a[i]\\) as the
time in which node \\(i\\) is inserted to the tree. We'll use the following
\\(a=42315\\) for illustration. Assume \\(1\\) indexing to refer to both the index in
\\(a\\) and also the node number.

Then since \\(a[4] = 1\\) then node \\(4\\) be inserted first, becoming the root. This
divides the tree into two parts (it is a BST). Since there is only one more node
to the right of node \\(4\\) we will just add node \\(5\\) as a right child of node \\(4\\).

For the left subtree, again we find the next smaller index, in this case \\(a[2]\\),
this means that node \\(2\\) will be the left child of node \\(4\\). Since there are
only two remaining nodes on the either side of node \\(2\\), nodes \\(1\\) and \\(3\\) will
be on both left and right braches from node \\(2\\) respectively.


## from permutation \\(a\\) to depth of nodes {#from-permutation--a--to-depth-of-nodes}

Let's take node \\(3\\) in the example above. Node \\(3\\) is at a depth of \\(3\\) (note
the depth of root is \\(1\\) according to the problem). Looking to the left of node
\\(3\\), only node \\(2\\) can be a possible ancestor of node \\(3\\), since node \\(2\\) comes
before node \\(3\\) (\\(a[2] < a[3]\\)). One can make a similar argument to the right of
\\(3\\), node \\(4\\) can be an ancestor of \\(3\\), since \\(a[4] < a[3]\\). Since node \\(3\\) is
a descendant of two nodes \\(2\\) and \\(4\\) its depth must be 3. One might argue that
it is possible that node \\(2\\) lies on one branch of node \\(4\\) and node \\(3\\) lies in
another branch of node \\(4\\). This is not possible because both nodes \\(2\\) and \\(3\\)
lie on the same subtree since they both come after node \\(4\\) and lie to the same
side of node \\(4\\).

Note the independence of left and right sides from the previous statement, it
doesn't matter whether node \\(2\\) is below or above node \\(4\\) from \\(3\\)'s
perspective, it only needs to know how many ancestors are above it. This will
come in handy later.

Node \\(3\\) was kind of obvious, we look to the left and right and found two nodes
that were ancestors to it. If we examine node \\(1\\) it is a little bit more
tricky. If you apply the same logic as before, nodes \\(2,3,4\\) all have \\(a[2 .. 4]
< a[1]\\) they all could be potential ancestors for \\(1\\). If you think of them in
order, however, you will note the following. For \\(a[4]\\), it is clear that it is
the root, everything to its right is irrelevant to \\(1\\). For \\(3\\) it is not clear
whether it is an ancestor of \\(1\\). Node \\(1\\) could potentially lie on \\(3\\)'s left
branch from its positioning, unless there is a node between \\(3\\) and \\(1\\) that
separates them into separate branches. Indeed there is such a node: \\(2\\). Node
\\(2\\) comes before \\(3\\) and therefore separates \\(1\\) from \\(3\\) into different
subtrees. In fact when examining node \\(3\\) we just have to find a node \\(j\\)
between \\(1\\) and \\(3\\) such that \\(a[j] < a[3]\\). To simplify further, we need to
look for the minimum node \\(j\\) between \\(1\\) and \\(2\\) to separate the two sides,
potentially discarding further possibilities.

So in general when we look for the possible ancestors of a particular node \\(i\\),
when considering a node \\(j \ne i\\) as a potential candidate, we only need to find
the some minimum between \\(a[i .. j]\\) to determine if node \\(j\\) could be a
potential ancestor. This is the symmetric for a point \\(j\\) to the left of \\(i\\).

Thus one comes to the following formula in the solution:

\\[
d\_i(a)=1+\sum\_{1\le j<i}(a[j] == \min(a[j\ldots i]))+\sum\_{i<j\le n}(a[j] ==
\min(a[i\ldots j])).
\\]

The first \\(1\\) on the RHS, denotes the default depth of the root, then
the first sum denotes the elements to the left of node \\(i\\) and the second sum
denotes the elements to the right of node \\(i\\).   It would have been a little bit
clearer to add an indicator function in front of the condition.

\\[
d\_i(a)=1+\sum\_{1\le j<i}\mathbf{1}(a[j] == \min(a[j\ldots i]))+\sum\_{i<j\le n}\mathbf{1}(a[j] ==
\min(a[i\ldots j])).
\\]


## independence property {#independence-property}

We have already alluded that \\(\min(a[j\ldots i])\\) and \\(\min(a[i\ldots j])\\) count
independently from one another.  This means that there might be an single
permutation that contains both a left and right ancestor for node \\(i\\).  These
two need to be counted twice, even though they come from the same permutation.
In other words, we are free to sum up allowable permutations for left
independently from the allowable permutations for the right, even if they
are the same permutation (i.e. no overcounting).

On the other hand we have to be careful about counting \\(\min(a[j\dots i])\\) (and
by symmetry on the other side) points that lie on the same side. Suppose there
are two points \\(j'\\) and \\(j\\) where \\(j' < j\\), that is, \\(j'\\) is to the left of \\(j\\).
Since \\(a[j']\\) is a minimum from \\(j'\\) to \\(i\\), we cannot count permutations that
include \\(j\\) as the mininum. On the other hand if \\(a[j]\\) is the minimum from \\(j\\)
to \\(i\\), then it does not matter whether \\(j'\\) is a minimum, why? If \\(a[j'] <
a[j]\\) then those permutations would have been counted when considering \\(a[j']\\)
and they count separately from the contributions of node \\(j\\). If \\(a[j'] > a[j]\\)
then node \\(j'\\) would not been a potential ancestor. Thus one can see that
"outer" ancestors must exclude the possibility of smaller "inner" ancestors,
since by definition they the "outer" ancestor comes earlier than any other
"inner" ancestor.


## generating functions to count inversions {#generating-functions-to-count-inversions}

With the independence property, we can now independently consider contributions
of depth to a particular node, say node \\(i\\).  For a particular node \\(i\\) we will
also consider a particular node \\(j\\) that is a potential ancestor and tabulate
how many permutations have node \\(j\\) as \\(i\\)'s ancestor.  We are free to tabulate
all these permutations as long as they follow two rules.

One, the total number of inversions has to be \\(k\\) and two, for these
permutations there are no node \\(j\\) is smaller than nodes \\(i\ldots j\\).

We can count the number of permutations available by counting the possible
inversions at each index.  For example at index \\(i\\) there is only one possible
inversion, namely \\(0\\), since this is a reference point.  For \\(i+1\\), there are two
possible inversions, \\(a[i]\\) and \\(a[i+1]\\) are either in order or not.  For \\(i+2\\)
there are three possible inversions, and so on.  Each of these possibilities can
be captured by a generating function, and the combined convolution of these
possibilities can be capture as the product of the individual sums as
\\((x\_0)(x\_0+x\_1)(x\_0+x\_1+x\_2)\cdots(x\_0+x\_1+\ldots+x\_{j-1})\\)  At \\(j\\), we know
that the \\(a[j] == min(a[i\ldots j]\\) therefore there is only one possibility for
the \\(j\\) term, \\(j\\) inversions or \\(x\_j\\).  for the \\(j+1\\) term, it is allowed to
have any number of inversions, since there is no restriction on its value.  If
\\(a[j+1]\\) is smaller than \\(a[j]\\) then this scenario will be counted when
setting \\(j\\) to this number, and as we mentioned before the permutations of this
"outer" ancestor does not precude the counting of "inner" ancestors.  This
continues until \\(a[j + (n-j)]\\) for which there are \\(0\\) to \\(n-i+1\\) inversions
possible.

Next we continue counting on the left side of \\(a[i]\\), for \\(a[i-1]\\). This doesn't
have any restrictions and therefore we can consider inversions fomr \\(i-1\\) to
\\(n\\), with a possibility of \\(0\\) to \\(n-i+2\\) inversions.  Note that this way of
enumerating inversions by looking at only possibilities to the right of number
ensures that no inversion is missed, or overcounted.  We continue in this
fashion until \\(a[i-(i-1)]\\) which can have \\(0\\) to \\(n-1\\) inversions.

Thus the accounting of all possible number of permutations for each number of
inversion is capture in the coefficient of the \\(x\_k\\) term of the polynomial.
The effect of the \\(j\\) th term can be separated by multiplying by

\\[
\frac{x\_0 + x\_1 + \ldots + x\_{j-i}}{x\_0 + x\_1 + \ldots + x\_{j-i}}
\\]

Thus arriving at

\\[
\prod\_{t=1}^{n}\left(\sum\_{u=0}^{t-1}x^u\right)\cdot
\frac{1}{\sum\_{u=0}^{j-i}x^u}\cdot x^{j-i}.
\\]


## convolution with rectangles {#convolution-with-rectangles}

```c++
void ad(vmi& a, int b) { // multiply by (x^0+x^1+...+x^{b-1})
  a.rsz(sz(a)+b-1);
  R0F(i,sz(a)-b) a[i+b] -= a[i];
  FOR(i,1,sz(a)) a[i] += a[i-1];
}
```

The easiest way to to think about this convolution is as a sliding window of
length \\(b\\).  As in a sliding window, it is easier keep a running sum, and
sliding the window remove one item from the back and insert a new element at
the front.  The only thing that this does differently is removing the
prior to computing the running sum.

Another way to think about a convolution with a rectangle is a convolution with
a superposition of step functions.

\\[
{\displaystyle \Pi\left({\frac {t-X}{Y}}\right)=u(t-(X-Y/2))-u(t-(X+Y/2))}
\\]

Further if we recognize the step function as the integral of a delta function:

\\[
{\displaystyle H(x):=\int \_{-\infty }^{x}{\delta (s)}\ ds}
\\]

Then we can first convolve with the delta function followed by an integral.

\begin{aligned}
f \* \Pi((x-b/2)/b) &= f \* (H(x) - H(x-b)) \\\\\\
&= \int\_{-\infty}^{x} f \* (\delta(s) - \delta(s-b))\ ds\\\\\\
&= \int f(s) - f(s-b)\ ds
\end{aligned}

Thus the function in the code shifts \\(a[]\\) by \\(b\\) adds it to \\(a[]\\) and then
calculates a prefix sum.

```c++
void sub(vmi& a, int b) {
  ROF(i,1,sz(a)) a[i] -= a[i-1];
  F0R(i,sz(a)-b) a[i+b] += a[i];
  a.rsz(sz(a)-b+1);
}
```

The `sub` function does the exact opposite, it differentiates \\(a[]\\) then adds
back a shifted amount back.  This corresponds to dividing by the polynomial
\\((x\_0 + \ldots + x\_{j-i})\\)


## left and right {#left-and-right}

```c++
int main() {
  setIO("treedepth");
  cin >> n >> k >> MOD;
  vmi v = {1}; FOR(i,1,n+1) ad(v,i);
  vmi ans(n,v[k]);
  FOR(dif,1,n) {
    sub(v,dif+1);
    mi x = get(v,k-dif), y = get(v,k);
    ad(v,dif+1);
    F0R(a,n-dif) {
      ans[a] += x;
      ans[a+dif] += y;
    }
  }
  F0R(i,n) cout << ans[i].val << ' ';
}
```

The first \\(~ad\\) basically sets up the generating for all permutations.
Then we populate the answer with all the permutations with \\(k\\) inversions.  This
corresponds to adding the \\(1\\) in \\(d\_i(a)\\).  Then we remove a set of permutations
containing \\(0\\) to \\(|j-i|\\) inversions.  `x` corresponds \\(j>i\\) for which we
need to take into account the inversions for the \\(j\\) th element.  And `y`
correponds \\(j<i\\) for which there are no inversions caused by element \\(j\\).
These two steps can be thought as adding the right most two terms in \\(d\_i(a)\\).
However, for a particular \\(i\\) this is not done at the same time, but eventually
all \\(|j-i|\\) are considered in the innermost for loop.

Credits, thanks Benjamin, Anup, and Santosh.
