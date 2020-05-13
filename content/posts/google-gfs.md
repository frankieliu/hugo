+++
title = "Google File System"
author = ["adam"]
date = 2020-05-09T10:08:17-07:00
lastmod = 2020-05-09T11:16:19-07:00
tags = ["distributed systems", "file systems", "gfs"]
categories = ["distributeed systems", "file systems", "google"]
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

## 5.1 High Availability {#5-dot-1-high-availability}


### Chunk Replication {#chunk-replication}

-   RF of 3
-   master clones existing replicas when chunkservers go offline or detect
    corrupted replicas


### Master Replication {#master-replication}

-   operation log and checkpoints replicas
-   "shadow" masters provide read-only access
    -   file metadata like directory contest could be stale
    -   reads replica information from logs
    -   pools from chunkservers to locate chunk replicas
    -   depends on primary for decisions to create and delete replicas


## 5.2 Data Integrity {#5-dot-2-data-integrity}

-   impractical to very replica data between replicas
-   use 32bit checksum on 64KB blocks
    -   stored persistently with logging and separate from user data
-   in reads:
    -   chunkserver verifies the checksum before returning data
    -   client reads from another replica
    -   master creates a different replica and delete the corrupted one
-   in appends:
    -   incrementally update the checksum for last partial checksum blocks
    -   even if last partial checksum is corrupted, new checksum value will
        not match stored data and corruption will be detected
-   in writes:
    -   if write overwrites an existing range on the chunk, need to verify
        the first and last blocks of the range being overwritten
    -   calculate new checksums based from previous checksum so that corruption
        of unchanged areas will be detected


## 6 Measurements {#6-measurements}

-   1 master, two master replicas, 16 chunkservers, and 16 clients


## 6.1.1 Reads {#6-dot-1-dot-1-reads}

-   random 4MB read from 320 GB file set
-   chunkservers only have 32 GB of memory, expect at most 10% hit rate
-   theoretical limit 125MB/s with 1Gbps link becomes saturated
    -   12.5 MB/s per client when 100Mbps network interface gets saturated
    -   observed 10MB/s when one client reading
    -   aggregate read 94 MB/s for 16 readers


## 6.1.2 Writes {#6-dot-1-dot-2-writes}

-   1GB of data in 1MB writes
-   Limits at 67 MB/s because need to write each byte to 3 of the 16 chunkservers
    each with a 12.5 MB/s input
-   write rate for one client is 6.3MB/s - delays in propagating data to replicas
-   aggregate 35MB/s for 16 clients, multiple clients writing concurrently to same
    chunkservers


## 6.1.3 Appends {#6-dot-1-dot-3-appends}

-   limited by BW of the chunkservers storing the last chunk of the file


## 6.2.4 Master Load {#6-dot-2-dot-4-master-load}

-   200-500 ops/s
-   master bottlenecs scanning through large directories looking for particular
    files, change to binary seraches through namespace


## 6.2.5 Recovery time {#6-dot-2-dot-5-recovery-time}

-   experiment: kill chunkserver with 15,000 chunks 600GB of data
-   what does 91 concurrent clonings mean?


## 6.3.2 Chuckserver Workload {#6-dot-3-dot-2-chuckserver-workload}


### Bimodal {#bimodal}

-   small reads <64KB from seek-intensive clients
-   large reads >512KB from long sequential reads
-   small writes for clients that checkpoint or sync more often
-   large writes for clients that do more buffering


## 6.3.3 Appends vs Writes {#6-dot-3-dot-3-appends-vs-writes}

-   100x more appends than writes
-   mutations are mostly appends and not overwriting


## 6.3.4 Master Workload {#6-dot-3-dot-4-master-workload}

-   FindLocation - request for chunk locations (for reads)
-   FindLeaseLocker - lease holder information (for mutations)


## 7 Experiences {#7-experiences}


### RW lock {#rw-lock}

lock blocked network thread while disk threads were paging in previously mapped
data, solution let threads read from a copy so that network thread is not blocked


## Summary {#summary}


### design space {#design-space}

-   common failures
-   optimize for huge files
-   most append only and sequential reads


### fault tolerance {#fault-tolerance}

-   constant monitoring
    -   checksum to detect data corruption
-   replicating crucial data
    -   chuck replication
-   fast and automatic recovery
    -   online repair system compensates for lost resplicas asap


### high throughput {#high-throughput}

-   separate file system control from data transfer
-   file system control handled by master
-   data transfer handled by chunkservers
-   master involvement is minimized
    -   large chunk size
    -   chunk leases - delegates authority to primary replicas
