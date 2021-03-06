+++
title = "1197 Minimum Knight Moves"
author = ["adam"]
date = 2020-03-29T22:44:44-07:00
lastmod = 2020-08-12T19:59:47-07:00
tags = ["leetcode"]
categories = ["leetcode"]
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

{{< figure src="/images/1197-knight/knights.svg" >}}

It is easy see that if you start in a spot in the diagonal, you can get back to
the diagonal in two moves. Say E-NE followed by N-NE, where I am using the the
North, South, East and West conventions. Similarly for a knight at the x-axis
you can get back to the x-axis with E-NE followed by E-SE.

Let's take a look at the diagonal section of 4,4,4 (pink), since I can get back
to the diagonal in two moves, the next section has 6,6,6 (beige). Similarly in
you take a look at the horizontal section 2,3,4,5 (red) in two moves you will
get back to the horizontal at 4,5,6,7 (green).  The pattern breaks close to 0,0,
but interestingly it only breaks at two coordinates (0,1) and (2,2), so these
become two special conditions to check for.

Now let's formulate the number of moves from a diagonal element at \\((x,x)\\) to
the origin,

\\[
2\left\lceil \frac{x}{3} \right\rceil
\\]

and for an element on the x-axis at \\((x,0)\\) to the origin,

\\[
2\left\lfloor \frac{x}{4} \right\rfloor + x\text{ mod } 4
\\]

The only remaining part is the number of moves required to move a piece to
either the diagonal or the x-axis. First note that by symmetry we can always
transform a point \\((x,y)\\) into a point in the lower half of the first quadrant
via reflections over the x-axis, y-axis or \\(x=y\\). At this lower half of the 1st
quadrant an optimal move from a far-away \\((x,y)\\) where \\(x>y\\) to the origin is
always W-SW, unless at the boundaries of this region. This means that a piece
beginning above the \\(y=\frac{1}{2}x\\) line (orange section), will always hit a
diagonal element in \\((x-y)\\) moves because \\(x>y\\) and for every W-SW move the
difference goes between \\(x\\) and \\(y\\) goes down by one. Similarly for an element
below the \\(y=\frac{1}{2}x\\) line will hit the x-axis in \\(y\\) moves since a W-SW
move decrements in \\(y\\) by one. If an element begins at the \\(y=\frac{1}{2}x\\) it
obviously will take \\((x-y)\\) moves to reach the origin. So finally we have the
following: for points above \\(y=\frac{1}{2}x\\), the total number of moves is

\\[
(x-y) + 2\left\lceil \frac{x-2(x-y)}{3} \right\rceil
\\]

and for an element below \\(y=\frac{1}{2}x\\),

\\[
y + 2\left\lfloor \frac{x-2y}{4} \right\rfloor + (x-2y) \text{ mod } 4
\\]

I keep it unsimplified so that it is easy to trace the formula. If \\(x-2(x-y)\\)
lands at 2 or if \\(x-2y\\) lands at 1 then we take special cases respectively, 4
and 3 as mentioned above. And for elements at \\(y=\frac{1}{2}x\\), it will take
\\(x-y\\) moves.