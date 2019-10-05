+++
title = "920 Number of music playlists"
author = ["adam"]
date = 2019-08-30T19:13:32-07:00
lastmod = 2019-10-04T18:17:56-07:00
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
  identifier = "920-number-of-music-playlists"
  weight = 2001
+++

## Notes on solution to Leetcode 920 {#notes-on-solution-to-leetcode-920}

Let's take the example from the article, songs: \\(\left\\{abcde\right\\}\\),
playlist: \\(abacabdcbaeacbd\\),

\\(\bar{x} = (1,2,4,7,11)\\)

For \\(\bar{x}\\), each number in the n-tuple indicates a position in the playlist
for the first occurrence of a particular unique song. The article uses
1-indexing so I will use the same to be consistent.

As an example for the \\(\bar{x}\\) above, consider the playlist family:

\\(p\_l = (1\_1,2\_2,c\_3,3\_4,c\_5,c\_6,4\_7,c\_8,c\_9,c\_{10},5\_{11},c\_{12},c\_{13},c\_{14})\\)

Here I have used the numbers (characters) \\(1-5\\), to indicate a song number,
instead of the \\(a-e\\) in the article. The subscripts indicate the position in
\\(p\_l\\) for ease of reference. And I will refer to the song as characters in a
string for simplicity. The characters \\(c\\) in \\(p\_l\\) indicate the possible
characters that may be inserted at that position. Note that for the character
\\(c\\) at position 3, since I have only seen \\(2\\) unique songs so far, \\(c\_3\\) must
come from \\(\left\\{1,2\right\\}\\) whereas for \\(c\_{5,6}\\) must come from the set
\\(\\{1,2,3\\}\\) since I have only seen \\(3\\) unique songs so far.

Now take in consideration the restriction of \\(K\\), it implies that there must be
a window \\(K+1\\) of non-repeating characters. Let's take \\(K+1 = 2\\) for the example
above. That means for the \\(c\_3\\), its choice of characters must come from the set
\\(\left\\{1,2\right\\}\\) and in addition it must be different from character at
position \\(2\\) ("\\(2\\)" in the example above). This restriction implies that there
is only one possible choice for \\(c\_3\\), namely "\\(1\\)". We will count this
possibility as \\(1^\delta\\), where \\(\delta\\) denotes the number of characters
between the first occurrence of the \\(K+1\\) th character and the first occurrence
of the \\(K+2\\) th character, or \\(x\_{K+2}-x\_{K+1}-1\\) from \\(\bar{x}\\). Similarly for
\\(c\\) at positions \\(5\\) and \\(6\\), their choice must come from the set
\\(\left\\{1,2,3\right\\}\\) and in addition it must differ from the previous \\(K\\)
characters, translating to a choice of two characters for \\(c\_{5,6}\\). We will
count this possibilities as \\(2^\delta\\), where \\(\delta\\) here denotes the number
of characters between \\(K+2\\) and \\(K+3\\) characters (first occurrences), or
\\(x\_{K+3} - x\_{K+2} - 1\\).

The careful reader will note that I count the first \\(K+1\\) characters as being
unique, whereas the article counts the first \\(K\\) characters. My suspicion is
that the author also thinks in terms of a window of \\(K\\) unique characters rather
than of \\(K+1\\) characters, thus interchanging the usage of the \\(K\\) previous other
characters with the window length for unique characters. To be consistent, I
stick with the definition of \\(K\\) in the problem statement.

Given \\(N\\), \\(L\\), and \\(K\\), how many \\(\delta\\)'s are there? This should be equal to
the number of unique characters discounting the grouping at the beginning or
\\(N-K \equiv P\\). Conveniently, the article suggests adding a \\(x\_{N+1} = L+1\\) to
\\(\bar{x}\\) so the last \\(\delta\\) can be determined from \\(\bar{x}\\).

Given \\(N\\), \\(L\\), and \\(K\\), what is the sum of \\(\delta\\) values? Since each \\(\delta\\)
for a given \\(\bar{x}\\) corresponds to the spacing between first occurrences, the
total sum of spaces plus the unique characters must sum to \\(L\\), in other words,
\\(\sum \delta\_i + N = L\\), or \\(\sum \delta\_i = L-N \equiv S\\), where I have appended
a subscript \\(i\\) to enumerate each spacing. Note that a vector of \\(\delta\_i\\)'s
uniquely determines an \\(\bar{x}\\). So an enumeration of all possible \\(\bar{x}\\) is
equivalent to enumerating all possible \\(\bar{\delta}\\), where a \\(\bar{\delta}\\)
denotes a n-tuple of \\(\delta\_i\\)'s corresponding to some \\(\bar{x}\\). The article
expresses the sum of all these enumerations as
 \\[
 \sum\_{\bar{\delta}\ \rm{ s.t. }\sum \delta\_i = S} \cdots
 \\]
To be consistent with the definition of \\(K\\) in the problem, the final answer
should almost match the one in the article
\\[
N! \left( \sum\_{\bar{\delta}} \mathop{\LARGE\Pi}\_{j=1}^{N-K} j^{x\_{K+1+j}-x\_{K+j}-1} \right)
\\]

For the answer utilizing the generating functions, the key idea is as follow,
you are looking for all combinations of \\(P\\) numbers that sum up to a number \\(S\\).
The \\(x^S\\) coefficient of the generating function is conveniently the sum of all
possible \\(j^\delta\\) products. Since each infinite geometric series in the
generating function can be expressed as simple fraction, the generation function
becomes the product of simple fractions.

The product of fractions can be expanded to the sum of partials fractions. Since
each partial fraction has the form of the sum of an infinite geometric series,
we just return the \\(x^S\\) term from each of the partial fractions.

The only other thing not mentioned in the article, but used in the code is
finding the inverse of a number in a modulo ring. One way to get the inverse of
a number is to use the extended Eucledian algorithm. Instead, for modulo \\(p\\),
where \\(p\\) is prime, we can use Fermat's little theorem, which says that \\(a^p
\equiv a \mod p\\), so \\(a^{p-1} \equiv 1 \mod p\\), and \\(a^{p-2} \equiv a^{-1}
\mod p\\), which shows up in the article's solution.
