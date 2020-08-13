+++
title = "818 Race Car"
author = ["Frankie Liu"]
date = 2020-08-11T20:56:27-07:00
lastmod = 2020-08-12T19:49:56-07:00
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
+++

## Proof {#proof}

Consider overshooting \\(t\\) by \\(2^{n}-1\\), where \\(n\\) is the smallest
integer that overshoots the target.

We would like to prove considering a jump \\(2^{n+1}-1\\) is not going to
yield a shorter set of actions.

Note that \\(t\\) is in \\([2^{n-1},2^n-2]\\), so from point A we have a
remaining distance in \\([2^n+1, 3(2^n)-1]\\).  Again if we consider the
possible jumps from A, either we jump to \\(2^{n}-1\\) or \\(2^{n+1}-1\\).  Of
course we will not take \\(2^{n+1}-1\\) because that would mean we arrive
back at the beginning.  If we take \\(2^{n}-1\\) then we would be at
location \\(2^{n}\\) in \\(2n+2\\) steps (\\(n+1 + n + R\\)).  Note we could have
gotten to the same location via a forward \\(2^{n}-1\\) step followed by
\\(RRAR\\) or \\(n+4\\) steps.  The difference is \\(n-2\\) so as long as \\(n>2\\) it
never makes sense to make the longer jump, but also note that the
ending speeds are different.  In the former, one would have to slow
down the speed which would lead to further \\(RR\\) steps thus making it
always unfavorable to take the \\(2^{n+1}-1\\) step.

Note that part of the above reasoning also calls for the fact that one
must not repeat any of the \\(2^{k}-1\\) jumps, because if there is a
repetition one can combine the two \\(2^{k}-1\\) jumps, into a longer
\\(2^{k+1}-1\\) jump and a \\(RAR\\), which is shorter.  This reasoning calls
for taking the longest jump available as opposed to a series of
shorter equal length jumps, since two shorter equal length jumps can
be more effectively done with one longer jump.