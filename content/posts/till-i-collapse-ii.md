+++
title = "Codeforces Till-I-Collapse (Part II)"
author = ["adam"]
date = 2020-06-29T14:14:24-07:00
lastmod = 2020-06-30T17:43:39-07:00
tags = ["segment tree", "binary indexed tree", "codeforces"]
categories = ["segment tree", "binary indexed tree", "codeforces"]
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

## credits {#credits}

It is interesting that MiFaFAOvO's solution has the same pieces are
ershov.stanislav's solution. In fact they both use the worm method (my own
naming for subsequence like states). What is interesting from MiFaFAOvO's
solution is that he uses a BIT to solve the problem.


## what kind of tree is a BIT {#what-kind-of-tree-is-a-bit}

While the update part of a BIT is pretty straightforward one may wonder at the
reverse query part which was done in ershov's solution \\(O(\log n)\\).

In that I already mentioned that one should make full advantage that the segment
tree is just like a normal binary tree with left and right children.

For a BIT however, it is not so clear how one can answer the same query.

For this one needs to really understand BITs.


## bit assignment {#bit-assignment}

Underlying a BIT is the fact that a number can be broken down as a sum of
powers of 2, i.e. a number's binary representation of a number.  But let's
be explicit and write it out:

\\[
28 = 16 + 8 + 4 = 0b11100
\\]

Now to obtain the prefix sum from index 1 to 28.  One would add the following
nodes in a BIT:

\\[
\sum\_{i=1}^{28} a\_i = t[16] + t[24] + t[28]
\\]

Note the separation between the indexes above, they correspond to the powers of two
representation of \\(28\\)

\begin{eqnarray}
16  = 16 - 0 \\\\\\
8   = 24 - 16 \\\\\\
4   = 28 - 24
\end{eqnarray}

-   \\(t[16]\\) is responsible for the range \\([1,16]\\)
-   \\(t[24]\\) is responsible for the range \\([17,24]\\)
-   \\(t[28]\\) is responsible for the range \\([25,28]\\)

or written in another way

-   \\(t[16]\\) is responsible for the range \\((0,16]\\)
-   \\(t[24]\\) is responsible for the range \\((0+16,0+16+8]\\)
-   \\(t[28]\\) is responsible for the range \\((0+16+8,0+16+8+2]\\)

One often finds the following form for the region of responsibility
\\(t[n]\\) is responsible for the range

\\((n-(1<<r), n]\\) or \\([n-(1<<r)+1, n]\\)

note that the right version is what you will often see, I prefer the left
version because the extra one doesn't come to a nice 'round' number, i.e. I
prefer to think of (16,24] vs [17,24]. In the above \\(r\\) is the bit position
counting from the right of the right most 1 in the number. For \\(0b11100\\), this
occurs at the third position from the right (or \\(2^2\\)), and thus the region of
responsibility for \\(0b11100\\) is \\((0b11000, 0b11100]\\).

Thus one can easily write

\begin{eqnarray}
S(0,0b11100) &=& t[0b10000] + t[0b11000] + t[0b11100]\\\\\\
&=& S(0,0b10000] + S(0b10000,0b11000] + S(0b11000,0b11100]
\end{eqnarray}

where I am using the notation \\(S(x,y]\\) to denote the sum of \\(a\_i\\) from \\((x,y]\\).
If you don't like the open left interval, just add a \\(1\\) to \\(x\\). But maybe you
can see why I prefer the open notation.

Note that typical implementations of BIT uses the following to get at the right
most '1',

\\[
r = x\\&-x
\\]


## pictorial {#pictorial}

{{< figure src="/images/till-i-collapse/bit-region-cropped.svg" >}}

From the above picture, given a node number \\(n\\), we can figure out
the range of responsibility by taking a look at the right most '1' bit.
This will indicate the size of the range, and the remaining bits
determine the offset.


## reverse query {#reverse-query}

Thus we are positioned to figure out at what position does the prefix sum equals
to some \\(k\\).

Basically we will take the biggest chunk first and determine if we took too much
or not. If we took too much, then we must look for a smaller chunk. Kind of a
similar thing that we do in figuring out the binary representation of a number.
For example, suppose we are interested in the binary representation of \\(22\\). We
can begin by looking at the large powers of two, \\(32\\) is too big, then we look
for the next smaller power of two \\(16\\), this is smaller than \\(22\\) so we then
take the remainder \\(22-16 = 6\\) and again we look for the next power of two \\(8\\)
is bigger than \\(6\\) so we skip till we get \\(4\\) and again take the remainder
\\(6-4=2\\), etc.

The BIT stores things in the same way. Say we are looking for prefix sum
matching \\(k\\). Suppose that the answer is at position \\(22\\), i.e. \\(\sum\_{i=1}^{22}
a\_i = k\\). Then we can approach this by looking at largest range containing part
of the prefix sum, say \\((0,16]\\), since this smaller than the desired sum, we
take the remainder \\(k-t[16]\\) and look at the next extension of the prefix
\\((16,24]\\). We find that the sum in this range is larger than the remaining sum, so
we look for the next smaller range, \\((16,20]\\). In essence we zero on a prefix
range that contains the desired prefix sum.


## details of the search {#details-of-the-search}

Note that there may be multiple prefixes with the same sum, and we may want to
find the prefix with largest range matching a prefix sum. This problem also
appears in the segment tree version. We will treat both of these problems in a
separate article.
