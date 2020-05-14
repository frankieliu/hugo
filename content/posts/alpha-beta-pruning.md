+++
title = "Minimax - alpha beta pruning"
author = ["adam"]
date = 2020-02-01T18:50:57-08:00
lastmod = 2020-05-13T17:30:27-07:00
tags = ["minimax", "alpha beta pruning"]
categories = ["minimax"]
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

## Normal pruning {#normal-pruning}

{{< figure src="/images/alpha-beta/alpha-beta.png" >}}

Imagine you are given the following problem: Find the depth of the
the leaf closest to the root of a tree.

```python
def smallest_depth(node, depth):
    if node is None:
        return depth - 1
    a = smallest_depth(node.left, depth + 1)
    b = smallest_depth(node.right, depth + 1)
    return min(a, b)
```

You could improve this a little bit by passing some information to your children:

```python
def smallest_depth(node, smallest_sofar, depth):
    if node is None:
        return depth - 1
    if depth >= smallest_sofar:
        return depth
    a = smallest_depth(node.left, smallest_sofar, depth + 1)
    b = smallest_depth(node.right, min(a, smallest_sofar), depth + 1)
    return min(a,b)
```

In the case above, we give up search early if we cannot beat the best depth we
have seen so far. Note there are two aspects to this pruning, one is the
condition that stops the recursion, and the other is the update of the
`smallest_sofar` that gets passed down to child nodes. Let's generalize this a
bit more.

```python
def max_value(state, critical_max):

    if terminal_state(state):
        return utility(state)

    v = -1<<31
    for child in children(state):
        v = max(v, value(child, critical_max, v))
        if v >= critical_max:
            return v

    return v
```

In this case, I have not specified the `value` function. But it may need some
information about the running max `v` and the `critical_max` to stop its
evaluation early. What is known, however, is that this function (`max_value`)
calculates a running `max`, and there is a `critical_max` which is some upper
bound that must not be crossed. Or if it is crossed, further visitation on
`child` states are not necessary.

This is pretty close to alpha-beta pruning already.  Now, we just add the idea
that the `value` function for the next state is a `min_value` function, and we
pass to it a `critical_min` which will be the running max of this stage.  Why
should the running max be the `critical_min` of the following `min_value` stage?

Note current stage is keeping a running max value while the next stage is
computing a running min value. If the running min is smaller than the running
max there is no point in further making this value smaller. Thus the running max
gives a lower bound for the computation at the next stage. Note also that as the
current stage keeps increasing the running max, the following `min_value` calls
get successively tighter (increasing lower) bounds.

```python
def max_value(state, critical_max, critical_min):

    if terminal_state(state):
        return utility(state)

    v = -1<<31
    for child in children(state):
        v = max(v, min_value(child, critical_max, critical_min))
        if v >= critical_max:
            return v
        critical_min = max(critical_min, v)

    return v
```

The only thing that has been added here (in addition to the foregoing
discussion) is that a predecessor's `critical_min` may be tighter than the current
running max at this stage so it may over ride the current running max.

The code for the `min_value` function essentially mirrors this code:

```python
def min_value(state, critical_max, critical_min):

    if terminal_state(state):
        return utility(state)

    v = 1<<31
    for child in children(state):
        v = min(v, max_value(child, critical_max, critical_min))
        if v <= critical_min:
            return v
        critical_max = min(critical_max, v)

    return v
```

If you would like to change variable names, the `critical_min` is the alpha
and the `critical_max` is the beta in alpha-beta pruning.


## Mnemoic (older stuff) {#mnemoic--older-stuff}

Minimax, alpha beta.  Min comes before Max, alpha comes before beta.
Minimizer uses alpha for pruning, maximizer uses beta for pruning.


### Pruning {#pruning}

alpha is passed from maximizer to minimizer. maximizer says, beat a score of 10
(it wants something greater). minimizer gets one score of 8. minimizer stops
because it can't get above 8, it is a minimizer after all so exploration will
only reduce this score, and it will not be useful by the maximizer.

beta is passed from minimizer to maximizer.  minimizer says, give me something
smaller than 5.  maximizer gets one score of 6.  it stops because it can't get a
score less than 6 because it is a maximizer, any further exploration will only
make the score worse.


### Updating {#updating}

When do alpha and beta get updated?  Obviously alpha is something that maximizer
uses to inform the minimizer, so it is continuously updating the alpha as it
explores its options and finds a better score.  Similarly beta is updated by the
minimizer when it finds a lower score.
