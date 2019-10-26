+++
title = "Setting up mathjax for hugo"
author = "adam"
date = 2019-09-14T19:10:31-07:00
lastmod = 2019-10-26T08:16:07-07:00
tags = ["mathjax", "hugo"]
categories = ["hugo"]
draft = false
weight = 2002
+++

## Problem {#problem}

Adding mathjax support for posts


## Solution {#solution}

1.  Modify the current theme
2.  Add a partial template
3.  Add a parameter called mathjax: true in the frontmatter


## Details {#details}


### Modifying the current theme {#modifying-the-current-theme}

1.  Note that the current theme is set in config.tolm

<!--listend-->

```python
theme = "ananke"
```
