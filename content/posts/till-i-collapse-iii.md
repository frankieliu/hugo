+++
title = "Codeforces Till-I-Collapse (Part III)"
author = ["adam"]
date = 2020-06-30T15:22:25-07:00
lastmod = 2020-06-30T17:09:22-07:00
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

## extent of region {#extent-of-region}

We begin with the segment tree version.  Note that Ershov uses
a version of the segment tree where the right side of the range
of responsibility is open, i.e. \\([3,4)\\) is equivalent to \\([3,3]\\)

The function `get` below will find the size of the largest range
whose prefix sum is \\(k\\).

```cpp
int get(int v, int vl, int vr, int &k) {
  if (k >= st[v]) {
    k -= st[v];
    return vr - vl;
  }
  if (vl == vr - 1) {
    return 0;
  }
  int mid = (vl + vr) / 2;
  int res = get(v * 2, vl, mid, k);
  if (res == mid - vl) {
    res += get(v * 2 + 1, mid, vr, k);
  }
  return res;
}
```

It does so by allowing the \\(k\\) to go down to \\(0\\), while there are empty ranges
the recursion goes to the right child, until it reaches a single element range
containing an element (\\(>0\\)) at which point it returns \\(0\\). Thus the recursion
stops under the following two conditions: when the remaining \\(k\\) goes to \\(0\\) and
when we reach a leaf node of size greater than \\(0\\). Since the width of this leaf
node is not counted, we only count the size up to the element prior to this leaf
node.

The hard part about coming up with such a solution, is the fact that we are
stopping when we have gone past finding a \\(k\\) sum, and we stop when we find a
leaf node that meets this condition.


## Fenwick tree solution {#fenwick-tree-solution}

```cpp
int find(int x) {
  int p=0;
  for(int i=20;i>=0;i--) {
    if (p+(1<<i)<=n+1&&c[p+(1<<i)]<x) {
      x-=c[p+(1<<i)];
      p+=(1<<i);
    }
  }
  return p+1;
}
```

This code is a bit more convoluted, and Yuhao (MiFaFaOvO) when trying to
find the extent of the \\(k\\), actually looks for \\(k+1\\).  But the idea is
pretty simple: keep accumulating \\(p\\) as long as the accumulated range is
less than \\(k+1\\).  This can be seen from `c[] < x` in the `if` statement.
Then he returns \\(p+1\\) because that is the next potential starting of a
\\(k\\) subarray.  Another way to interpret the `find` function is to return
the smallest range containing \\(x\\) elements.  Note that the idea of finding
the shortest range containing \\(k+1\\) elements is equivalent to finding the
longest range containing \\(k\\) elements (plus \\(1\\)).


## contrast {#contrast}

Both methods are quite ingenious, and while I originally felt the BIT solution
to be hard to grok, after understanding how the BIT search works and looking at
the code from Yuhao, I think it is easier to implement and to understand,
whereas Ershov's code requires more careful thinking about the terminating
conditions. Note that the BIT solution requires just a linear walk with a `for`
loop through the search space, while the segment tree solution requires careful
orchestration in traversing the segment tree.  But your opinion may differ, if
you find a more intuitive way of explaning the above please let me know.
