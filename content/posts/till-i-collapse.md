+++
title = "Codeforces Till-I-Collapse"
author = ["adam"]
date = 2020-06-28T06:56:36-07:00
lastmod = 2020-06-28T23:41:44-07:00
tags = ["segment tree"]
categories = ["segment tree"]
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

This is ershov.stanislav's solution to the problem.

Given an array of integers (colors), find the mininum nunber of consecutive
grouping containing at most \\(k\\) colors (number of unique integers in a
subarray).

For a single \\(k\\) one can take \\(O(n)\\) time to greedily scan through the array and
accumulate \\(k\\) unique integers at a time.

However, given the size of the problem (\\(10^5\\)) and the fact that we
must do this for \\(k \in {1,\cdots,n}\\) implies that we must look for a better
solution.

Ershov's solution does a couple of neat little tricks:

-   every node of the tree gives the number of elements under it
-   the query is a reverse query for the range satisfying a particular condition

Updates happen from top to bottom.  When an element is added from the root, it
immediately adds to the root's value.  As it recursively goes down the tree, it
updates the nodes it encounters.  Note that the same can be done while on the
way back up the tree, as in the traditional sum segment tree.  However that note
doing on the way up requires the querying of the both the left and right childs,
so it is less efficient than updating directly while descending the tree.

The query is kind of an inverse range query.  Typically one asks for the
sum in a given range \\(l,r\\).  However in this case one is asking what range
satisfy some constraint.

In this particular example, we would like to know a prefix range \\((0,r)\\)
containing exactly \\(k\\) elements.

Since the segment tree is storing at each node how many elements in the
particular subtree, we can ask the following as we descend down the tree: does
the current subtree contain the solution or not. For example at a particular
node, we have the number of elements covered by that particular range.  If
this number is greater than \\(k\\) then the answer must be in this subtree.

Let's say we are looking for a prefix range covering 5 elements. Suppose that at
the current node we have 10 elements. Then we the upper bound for the range must
terminate in this subtree. We can recurse first to left child and check. If the
left branch has 4 elements, then we know we must look for the remaining element
in the right child.

How do we return a range? If a node contains less elements that the desired
number of elements, then we know that the answer must lie in the right child.
The parent can the remove the number of remaining elements that have not been
covered by the left branch and do a similar query to the right child for the
remaining elements.

Ershov's code automatically decrements the number of remaining elements as
it traverses the tree.  However it seems to do extra work in figuring the
extent of the range, i.e. why add the ranges and propagate them up?

I guess the alternative is to descend to the corresponding leaf node and
correctly percolate this result up the tree, I think this is just as good
doing the addition on the way up.

I have been talking about worms in subsequence problems.  I think
the particular solution falls into this category.  Worms can be thought as
possible solutions that exists at particular positions in the array.

For example, if at each position in the array we know how many worms
can originate from that position, then we can add to the count for that
particular worm.

Each worm has a particular characteristic, a \\(k\\) number.  Here the
characteristic corresponds to the number of unique characters in a
particular subarray.  The end position of a worm born at the \\(i\\) th
position can be determined using the segment tree.

At any particular point in time the segment tree keeps track of the
left most unique elements in the array beginning at a particular position
in the array.  For example, say we are at position 3 in the array, then
the segment tree will have information about the leftmost unique elements
for the suffix array from 3 to the end.

This information is useful because we can determine the end position of the
\\(k\\) - worm. Since the \\(k\\) - worm will be ending at the position in the segment
tree where we have accumulated exactly \\(k\\) distinct colors, let's call this
position \\(r\\). We store this information in an array \\(b[pos]\\) which contains
information about all the worms originating at position \\(pos\\).

Since we are considering beginning positions for each \\(k\\) - worm it makes sense
that we are interested in the next tail of the worm.  The segment tree only
keeps track of the location of the next unique elements from the current
position going forward.  Therefore we need to eliminate the unique elements
that have already been encountered before the current position and make
sure that we insert into the tree the next unique elements at the current
position and up.

This can be done by selectively removing the item at the previous position and
inserting the same color element if it comes later in the array. The idea is to
always keep a fresh set of new unique elements in the tree so that the
computation of the next worm head can be done in log time.

This is an interesting problem in that we tie up into thinking of a
particular way of using a segment tree and not notice that in fact a segment
tree is just a tree, so doing tree like operations such as finding the location
of the \\(k\\) th element on the tree should be possible.

For an estimate of the complexity, I came up with the following.  Say the
total range of numbers is \\(1\\) to \\(n\\).  Then there are about \\(n/2\\) worms of
size \\(k=2\\) and \\(n/3\\) worms of size \\(k=3\\), etc.  Then the total number of
worms in the range is roughly \\(n \log n\\).  Since we are enumerating all the
worms in the range and for each worm we need to query on the segment tree
to find the next head position the overall complexity is \\(n \log^2 n\\).

There are other factor involved including the calculation of the 'next'
numbers, but this will take \\(O(n)\\) and the updates of the segment tree
only occur \\(n\\) times, thus taking \\(O(n \log n)\\).

{{< figure src="/images/till-i-collapse/till-i-collapse.svg" >}}

In the above picutre, I display two unique colors at position 1 and 2.
As the cursor moves to another position, the green color at position 1
needs to find a correspond 'next' position in the segment tree.  Each
node in the segment tree stores the number of unique colors in its
subtree.  Thus we can query in log time for the location of the \\(k\\) th
unique color in \\(\log n\\) time.  Since there is roughly \\(\log n\\) such
queries per position, \\(n\\) positions, the total complexity is
\\(O(n \log^ n)\\)
