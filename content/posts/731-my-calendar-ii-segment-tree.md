+++
title = "731 My Calendar II"
author = ["adam"]
date = 2019-10-03T20:56:27-07:00
lastmod = 2019-10-04T18:33:02-07:00
tags = ["leetcode"]
categories = ["leetcode"]
draft = false
weight = 2001
foo = "bar"
baz = "zoo"
alpha = 1
beta = "two words"
gamma = 10
mathjax = true
[menu.main]
  identifier = "731-my-calendar-ii"
  weight = 2001
+++

## Acknowledgement {#acknowledgement}

Taken from fun4leet's My Calendar II wonderful article


## tl;dr {#tl-dr}

A max segment tree, with an incremental update function is sufficient for this
problem.  Max is used because such tree allows quick query of the max number
of bookings given a range.  Incremental update is useful because each time
`book` is called, one needs to increment the bookings in a particular range.


## Data structure {#data-structure}

4 things: a range \\([l,r]\\), data, lazy flag


### Implementation {#implementation}

```python
class segment_node:
    def __init__(self):
        self.range = [None,None]
        self.lazy = None

        # normal tree stuff below
        self.val = None
        self.left = None
        self.right = None
```


## API {#api}


### query(arange) {#query--arange}

-   check if query range is valid/invalid
-   normalize: deal with lazy propagation
-   return value if covers current segment
-   recurse on left and right subtrees
-   combine the left and right results

<!--listend-->

```python
def query(root, arange):

    # take care of edge cases
    if root is None:
        return 0
    i,j = arange
    si, sj = root.range
    if i>j or j<si or i>sj:
        return 0

    # normal case
    normalize(root)    # deal with lazy
    if i<=si and sj<=j:
        return root.val
    return fcombine(query(root.left, arange), query(root,right, arange))
```


### update(arange,val) {#update--arange-val}

-   check if arange is valid/invalid
-   normalize
-   if arange covers current segment, update segment, mark children as lazy
-   recurse to left and right subtrees with the same arange
-   propagate results from left and right subtrees back to parent node

<!--listend-->

```python
def update(root, arange, val):

    if root is None:
        return
    i,j = arange
    si,sj = root.range
    if i>j or j<si or i>sj:
        return

    normalize(root)
    if i <= si and sj <= j:
        root.lazy = val
        normalize(root)
        return
    update(root.left, arange, val)
    update(root.right, arange, val)
    root.val = fcombine(root.left.val, root.right.val)
```


### normalize {#normalize}

-   if lazy is not None, then update the node's value, push laziness to children

<!--listend-->

```python
def normalize(root):
    if root is None:
        return
    if root.lazy is not None:
        root.val = fupdate(root.val, root.lazy)
    si,sj = root.range
    if si < sj:
        if root.left is None or root.right is None:
           mid = (si + sj) // 2
           root.left = segment_node((si,mid), root.val)
           root.right = segment_node((mid+1,sj), root.val)
        elif root.lazy is not None:
            root.left.lazy = fupdate(root.left.lazy, root.lazy)
            root.right.lazy = fupdate(root.right.lazy, root.lazy)
    root.lazy = None
```


## For the problem {#for-the-problem}


### initialization {#initialization}

Root node contains the whole range (0, 1e9) with everything initialized to 0.

```python
root = segment_node((0,1000000000),0)
```


### book(arange) {#book--arange}

-   if \\(k>=2\\) in range, then adding this booking will result in a triple
    booking, function returns false
-   else update range and return true

<!--listend-->

```python
def book(arange):
    k = query(root, arange)
    if k >= 2:
        return False
    update(root, arange, 1)
    return True
```


## Complexity {#complexity}

In `book`, there is one query and one update, both of which take \\(\log(d)\\) where
\\(d\\) is the max range.  For \\(n\\) calls to `book`, \\(O(n \log d)\\).

In the worst case, each call to `book` generates a completely separate range.
Assuming this reaches down to leaf nodes, then \\(O(n \log d)\\) is used.


## K booking {#k-booking}

The only modification in `book` is to compare \\(k>=K-1\\).


## Full solution {#full-solution}

```python
class segment_node:
    def __init__(self, arange, val):
        self.range = arange
        self.lazy = None

        self.val = val
        self.left = None
        self.right = None

def query(root, arange):
    if root is None:
        return 0
    normalize(root)
    i,j = arange
    si,sj = root.range
    if i>j or j<si or i>sj:
        return 0
    if i <= si and sj <= j:
        return root.val
    return max(query(root.left,arange),query(root.right,arange))

def update(root, arange, val):
    if root is None:
        return
    i,j = arange
    si,sj = root.range
    if i>j or j<si or i>sj:
        return

    normalize(root)
    if i<=si and sj<=j:
        root.lazy = val
        normalize(root)
        return
    update(root.left, arange, val)
    update(root.right, arange, val)
    root.val = max(root.left.val, root.light.val)

def normalize(root):
    if root is None:
        return
    if root.lazy is not None:
        root.val = root.val + root.lazy
    si,sj = root.range
    if si < sj:
        if root.left is None or root.right is None:
            mid = (si + sj) // 2
            root.left = segment_node((si, mid), root.val)
            root.right = segment_node((mid+1,sj), root.val)
        elif root.lazy is not None:
            root.left.lazy = root.left.lazy + root.lazy
            root.right.lazy = root.right.lazy + root.lazy
    root.lazy = None

class MyCalendarTwo:
    def __init__(self):
        self.root = segment_node((0,1000000000),0)
    def book(self, start, end):
        arange = (start,end)
        k = query(self.root, arange)
        if k >= 2:
            return False
        update(self.root, arange)
        return True
```
