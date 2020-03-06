+++
title = "FFT"
author = ["adam"]
date = 2020-03-06T08:22:35-08:00
lastmod = 2020-03-06T11:08:35-08:00
tags = ["fft", "convolution"]
categories = ["fft", "convolution"]
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

## polynomials {#polynomials}

\\[
f(x) = A\_0 + A\_1 x + A\_2 x^2 + \cdots + A\_{n-1} x^{n-1}
\\]


## roots {#roots}

\begin{eqnarray}
x^{n} &=& 1 \\\\\\
x &=& e^{i \frac{2\pi}{n}}
\end{eqnarray}

Call \\(e^{i \frac{2\pi}{n}} = w\_n\\) the fundamental, then there are
\\(n\\) such roots, \\(w\_n^k\\) for \\(k = 0,\cdots,n-1\\).

The fourier transform is a vector of the polynomial evaluated at
each of the \\(k\\) roots.

\\[
F(k) = f(w\_n^k)
\\]

The FFT is a divide and conquer algorithm where instead of doing
\\(O(n)\\) computations for each fourier coefficient \\(F(k)\\), we break
up the problem into 2 subproblems of size \\(n/2\\) and do a merge which
is of order \\(n\\).  Thus \\(T(n) = 2T(n/2) + O(n)\\)

Consider taking the FT of the even powers f(x):

\\[
f\_e(x) = A\_0 + A\_2 x + \cdots
\\]

It's FT will look like

\\[
F\_e(k) = f\_e(w\_{n/2}^k) = f\_e(w\_n^{2k})
\\]

for \\(k = 0, \cdots, n/2-1\\).

Combining both the odd and even contributions we get

\begin{eqnarray}
F(k) &=& f(x=w\_n^k) \\\\\\
     &=& f\_e(x^2) + x f\_o(x^2) \\\\\\
     &=& f\_e(w\_n^{2k}) + w\_n^k f\_o(w\_n^{2k})
\end{eqnarray}

Note for \\(k = 0, \cdots, n/2 -1\\), this is well defined by \\(F\_e(k)\\)
and \\(F\_o(k)\\):

\begin{eqnarray\*}
F(k) = F\_e(k) + w\_n^k F\_o(k)\\\\\\
 \text{ for } $k \in [0,n/2-1]
\end{eqnarray\*}

We need to take care of \\(k = n/2, \cdots, n-1\\).

Rewriting \\(k = n/2, \cdots, n-1\\) as \\(k = n/2 + (0, \cdots, n/2-1)\\).
\\(k = n/2 + k'\\).
We can rewrite:

\\[
w\_n^{n+2k'} = w\_n^{2k'}
\\]

and

\\[
w\_n^k = w\_n^{n/2+k'} = -w\_n^{k'}
\\]

Thus we can write

\begin{eqnarray}
F(n/2+k') &=& f\_e(w\_n^{2k'} - w\_n^{k'} f\_o(w\_n^{2k'}) \\\\\\
          &=& F\_e(k') - w\_n^{k'} F\_o(k')
\end{eqnarray}
