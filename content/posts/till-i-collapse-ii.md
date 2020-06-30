+++
title = "Codeforces Till-I-Collapse (Part II)"
author = ["adam"]
date = 2020-06-29T14:14:24-07:00
lastmod = 2020-06-29T16:25:38-07:00
tags = ["segment tree", "codeforces"]
categories = ["segment tree", "codeforces"]
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
ershov.stanislav's solution.  In fact they both use the worm method
(my own naming for subsequence like states).  What is interesting from
MiFaFAOvO's solution is that he uses a BIT to solve the problem.


## what kind of tree is a BIT {#what-kind-of-tree-is-a-bit}

While the update part of a BIT is pretty straight forward one may wonder at the
reverse query part which was done in ershov's solution \\(O(\log n)\\).

In that I already mentioned that one should make full advantage that the segment
tree is just like a normal binary tree with left and right branches.

For a BIT however, there is not so clear how one can answer the same query.

For this one needs to really understand the underpinnings of a BITs.


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
\Sum\_{i=1}^{28} a\_i = t[16] + t[24] + t[28]
\\]

Note the separation of the indexes, they correspond to the powers of two
representation of 28

\begin{eqnarray}
16  = 16 - 0 \\\\\\
8   = 24 - 16 \\\\\\
4   = 28 - 24
\end{eqnarray}

Thus one can determine the region of responsibility in a BIT as
follows

-   \\(t[16]\\) is responsible for the range \\([1,16]\\)
-   \\(t[24]\\) is responsible for the range \\([17,24]\\)
-   \\(t[28]\\) is responsible for the range \\([25,28]\\)

One can find the following form for the region of responsibility

\\(t[n]\\) is responsible for the range \\((n-(1<<r), n]\\), note that left
end is left open, and \\(r\\) is the position of the LSB 1 in the number.
For \\(0b11100\\) the LSB is at the third position from the left, and
thus the region of responsibility for \\(0b11100\\) is \\((0b11000, 0b11100]\\).

Thus one can easily write

\begin{equation}
S[0b11100;0) &=& t[0b11100] + t[0b11000] + t[0b10000]\\\\\\
&=& S[0b11100;0b11000) + S[0b11000;0b10000) + S[0b10000;0)
\end{equation}

where I am using the notation \\(S[x,y)\\) to the sum of \\(a\_i\\) from
\\([x,y)\\).  If you don't like the open right sided end, one can just
add a one to \\(y\\), but I find it easier to look at the bits without
adding the extra 1.

From this it should be obvious to determine the size of a range.
For example \\(t[0b11100]\\) the right most \\(1\\) is at position \\(2\\) thus
the range that it covers should be of size \\(2^2\\).  Similarly
\\(t[0b11000]\\) the right most \\(1\\) is at position \\(3\\) thus the range
should cover a range that is \\(2^3\\) long.

Note that typical implementations of BIT use the following to get
at the LSB, \\(r = x&-x\\).


## reverse query {#reverse-query}

Thus we are positioned to figure out at what position does the
prefix sum equal to some \\(k\\).
