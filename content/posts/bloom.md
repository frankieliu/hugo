+++
title = "Bloom, count min sketch"
author = ["adam"]
date = 2020-05-30T07:18:38-07:00
lastmod = 2020-05-30T11:30:46-07:00
tags = ["bloom"]
categories = ["bloom"]
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

## Bloom {#bloom}


### Probability of false positive {#probability-of-false-positive}

Probability that BF reports positive set membership for an element that is not
in the set

\\[
{\displaystyle \varepsilon =\left(1-\left[1-{\frac {1}{m}}\right]^{kn}\right)^{k}\approx \left(1-e^{-kn/m}\right)^{k}.}
\\]

\\(k\\) is the number of hash functions, \\(m\\) is the number of bits in the array, and
\\(n\\) is the number of entries inserted into the table.

Obviously increasing \\(m\\) and decreasing \\(n\\) would decrease the \\(\varepsilon\\)
however \\(k\\) has a optimal point.


### Derivation {#derivation}

Probability that a certain bit is not set to 1 by a single hash function during
insertion of an element.

\\[
{\displaystyle 1-{\frac {1}{m}}}
\\]

Probability that the same bit is not set by the other \\(k\\) hash functions

\\[
{\displaystyle \left(1-{\frac {1}{m}}\right)^{k}}
\\]

After inserting \\(n\\) elements, then the probably of not hitting is further
reduced

\\[
{\displaystyle \left(1-{\frac {1}{m}}\right)^{kn}\approx e^{-kn/m}}
\\]

This is for a single bit not being set.

The probability of it being set is \\(1 - \\{\\}\\).  And raising it to the $k$th power
gives \\((1-\\{\\})^k\\), one arrives at the probability of error given above.


### Asymptotics and \\(k\\) for min \\(\varepsilon\\) {#asymptotics-and--k--for-min--varepsilon}

For large \\(k\\), the function goes to 1 and for \\(k=1\\) it goes to 1.  Thus there is
a minimum, obtainable from (just showing the exp approximation):

\\[
\frac{d}{dx}\left(1 - e^{-k x}\right)^x =
\frac{
\left(1 - e^{-k x}\right)^x
\left(k x - \left(1 - e^{-k x}\right) \log\left(1 - e^{-k x}\right)\right)}
{1 - e^{-k x}}
\\]

For the approx., \\(k\\) optimal is given by:
\\[
{\displaystyle k={\frac {m}{n}}\ln 2}
\\]

With minimum \\(\varepsilon\\),
\\[
{\displaystyle \ln \varepsilon =-{\frac {m}{n}}\left(\ln 2\right)^{2}}
\\]


### Number of elements in a bloom filter {#number-of-elements-in-a-bloom-filter}

\\[
{\displaystyle \left(1-{\frac {1}{m}}\right)^{kn}\approx e^{-kn/m}}
\\]

Recall the probabilty that a certain bit is not set, we can estimate the
size of the set by counting the number of set bits \\(X\\)

\\[
{\displaystyle \left(1-{\frac {X}{m}}\right) \approx e^{-kn/m}}
\\]

from which

\\[
{\displaystyle n^{\*}=-{\frac {m}{k}}\ln \left(1-{\frac {X}{m}}\right)}
\\]

With this one can do interesting counting, for example given the bloom fitler of
\\(A\\) and \\(B\\) and \\(A \cup B\\) one can estimate the size of the intersection \\(A
\cap B\\).


## Count min sketch {#count-min-sketch}

{{< figure src="/images/bloom/cms.png" >}}

\\(d\\) hash functions \\(h\_j\\), \\(|j| = d\\) (depth of the table)

\\(w\\) number of buckets (width of the table)

\\(C(j,b) = C\_j(b)\\) a counter for each element in a stream.

CMS:
\\[
\hat{f\_i} = \min\_{j} C\_j(h\_j(i))
\\]

\\(m\\) length of stream


### Theorem {#theorem}

With a probability of

\\[
{\displaystyle 1-\delta}
\\]

the error is at most

\\[
\varepsilon || \text{stream} ||\_1
\\]

by setting

\\[
w=\left \lceil \frac{e}{\varepsilon} \right \rceil
\\]

and

\\[
d=\left \lceil \ln\frac{1}{\delta} \right \rceil
\\]


### Proof {#proof}

For a particular \\(i\\), and \\(h\_j\\), and \\(b = h\_j(i)\\),

\\[
E[C\_j(b)] = f\_i + \frac{1}{w} \sum\_{j \ne i: h\_j(j)=b} f\_j \le f\_i + \frac{m}{w}
\\]

CMS only overestimates the count.

Using Markov's inequality, and some more steps:

\\[
Pr \\{\hat{f\_i} \ge f\_i + \frac{2m}{w}\\} \le \left( \frac{1}{d} \right)^d
\\]


#### Markov's inequality {#markov-s-inequality}

For non-negative RV a (a>0)

\\[
{\displaystyle \operatorname {P} (X\geq a)\leq {\frac {\operatorname {E}
(X)}{a}}}
\\]

Aside: nice proof:

\\[
{\displaystyle \operatorname {E} (X)=\operatorname {P} (X<a)\cdot
E(X|X<a)+\operatorname {P} (X\geq a)\cdot E(X|X\geq a)}
\\]

\\[{\displaystyle E(X)\geq 0\cdot P(X<a)+a\cdot P(X\geq a)\geq a\cdot P(X\geq a)}
\\]


## Hyperloglog {#hyperloglog}

{{< figure src="/images/bloom/hyperloglog-dash.png" >}}

Durand and Flajolet

{{< figure src="/images/bloom/loglog.png" >}}

Heule, Nunkesser, and Hall

{{< figure src="/images/bloom/hyperloglog-algo.png" >}}

\\[
{\displaystyle {\begin{aligned}x&:=h(v)\\j&:=1+\langle x\_{1},x\_{2},..,x\_{b}\rangle \_{2}\\w&:=x\_{b+1}x\_{b+2}...\\M[j]&:=\max(M[j],\rho (w))\\\end{aligned}}}
\\]

\\(x\\) for each element in stream
