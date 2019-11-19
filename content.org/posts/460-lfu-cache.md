
# Table of Contents

1.  [Requirements](#orgf557c6d)
2.  [Suggested DS](#org375263c)



<a id="orgf557c6d"></a>

# Requirements

-   O(1) insertion
    -   requires O(1) getting the least frequently used


<a id="org375263c"></a>

# Suggested DS

-   you need to keep track of how often a key has been accessed
-   use a map where the key is the frequency and the value is a double linked list
    -   you need a double linked list in order to quickly move an element in and out of this list
    -   in this regard it is similar to a LRU
-   since you need get O(1) need a map from key to nodes in the linked list

[[![img](/images/460-lfu/460-lfu-ds.png)]]

