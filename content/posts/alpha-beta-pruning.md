+++
title = "Minimax - alpha beta pruning"
author = ["adam"]
date = 2020-02-01T18:50:57-08:00
lastmod = 2020-02-01T18:59:00-08:00
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
+++

## Mnemoic {#mnemoic}

Minimax, alpha beta.  Min comes before Max, alpha comes before beta.
Minimizer uses alpha, maximizer uses beta.


## Pruning {#pruning}

alpha is passed from maximizer to minimizer. maximizer says, beat a score of 10
(it wants something greater). minimizer gets one score of 8. minimizer stops
because it can't get above 8, it is a minimizer after all so exploration will
only reduce this score, and it will not be useful by the maximizer.

beta is passed from minimizer to maximizer.  minimizer says, give me something
smaller than 5.  maximizer gets one score of 6.  it stops because it can't get a
score less than 6 because it is a maximizer, any further exploration will only
make the score worse.


## Updating {#updating}

When do alpha and beta get updated?  Obviously alpha is something that maximizer
uses to inform the minimizer, so it is continuously updating the alpha as it
explores its options and finds a better score.  Similarly beta is updated by the
minimizer when it finds a lower score.
