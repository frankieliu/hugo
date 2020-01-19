+++
title = "Zookeeper 2.3"
author = ["adam"]
date = 2020-01-18T19:24:37-08:00
lastmod = 2020-01-18T20:56:55-08:00
tags = ["zookeeper", "distributed system"]
categories = ["distributed system"]
draft = false
weight = 2000
foo = "bar"
baz = "zoo"
alpha = 1
beta = "two words"
gamma = 10
mathjax = true
+++

## api {#api}

1.  We recapped re the API.
2.  Basically try to derive it yourself.
3.  Next divide which ones are write vs read related.
4.  Note that the read related contain a watch.
5.  Note that the write related contain a version.


## guarantees or promises {#guarantees-or-promises}

1.  Next we guessed what are zookeeper promises
2.  Why have these two promises
3.  Why A-linearizable?


## async vs sync {#async-vs-sync}

1.  what part of the writing is async?
2.  example is large configuration file
3.  what does it mean to be pipelined and issued asynchronously
    1.  when a client issues a change, when does the system respond back with an
        ack?


## sync {#sync}

1.  typical exists('ready', () -> get('conf'..)) should work
2.  back channel communication can cause process to get('conf') prematurely (i.e.
    before it is ready).
3.  for these cases client can issue a sync
4.  what happens on a sync?
    1.  maybe enough to bring local server up to commit index
