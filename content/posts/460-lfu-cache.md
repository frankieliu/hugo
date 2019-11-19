+++
title = "Leetcode 460. LFU Cache"
author = ["adam"]
date = 2019-11-18T14:40:38-08:00
lastmod = 2019-11-18T17:22:48-08:00
tags = ["cache", "leetcode"]
categories = ["cache", "leetcode"]
draft = false
weight = 2000
foo = "bar"
baz = "zoo"
alpha = 1
beta = "two words"
gamma = 10
mathjax = true
+++

## Requirements {#requirements}

-   O(1) insertion
    -   requires O(1) getting the least frequently used


## Suggested data structures {#suggested-data-structures}

-   f: a map from frequency to a tuple containing the head and tail of a portion of a double linked list
-   kv: a map from key to a node in the double linked list
-   dll: a double linked list where the least frequent item is at the head of the list
-   node: element of dll, containing frequency info, as well a prev, next, value, the usual stuff

{{< figure src="/images/460-lfu/460-lfu.png" >}}


## put(a,v) {#put--a-v}

1.  find corresponding node via kv[a]
2.  delete node from its current position and insert it at
    the head of the next frequency, i.e. f[freq+1].head
3.  update its value
4.  delete head of double linked list and update f accordingly


## get(a) {#get--a}

same as put(a,v), but don't update the value, just return it


## some things to take care of {#some-things-to-take-care-of}

1.  if a not in kv
2.  if there is no entry for f[freq+1]


## comments {#comments}

I tried to make this as simple as possible, if you have some other ideas
please let me know.
