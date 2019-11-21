+++
title = "Rectangle counting"
author = ["adam"]
date = 2019-11-20T23:21:28-08:00
lastmod = 2019-11-20T23:42:48-08:00
tags = ["computational geometry", "rectangle"]
categories = ["computational geometry"]
draft = false
weight = 2000
foo = "bar"
baz = "zoo"
alpha = 1
beta = "two words"
gamma = 10
mathjax = true
+++

The problem is to count the number of rectangles (aligned to x and y
coordinates) that can be formed by a set of points. Answer from competitive
programmer Errichto.

```python
def num_rect(points):
    m = defaultdict(lambda: 0)
    answer = 0
    for p in points:
        for p_above in points:
            if p.y < p_above.y:
                answer += m[(p.y,p_above.y)]
                m[(p.y,p_above.y)] += 1
    return answer
```

Consider the following set of points:

| x | x | x |
|---|---|---|
| 1 | 2 | 3 |

This is for k = 3, there are 3 possible rectangles.
This can be gotten from (3 choose 2) = 3\*2/2 = 3
Or from the above process as 1 + 2 = 3

When you encounter the first point you don't have a
rectangle, when you encounter the second point, you
have exactly one rectangle, and when you encounter
the third point you can make two rectangles, and so
on.

There is an obvious algebraic connection between (k choose 2) = k(k-1)/2 and the
sum 1+2+3+...+k-1. Of course you can see that mathematically they are
equivalent, but this is the first time I have seen a non-algebraic reasoning to
this connection, that is why this is solution is kind of beautiful to me.
