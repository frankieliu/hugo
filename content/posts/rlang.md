+++
title = "R lang"
author = ["adam"]
date = 2019-10-04T22:35:02-07:00
lastmod = 2019-10-05T04:12:33-07:00
tags = ["R"]
categories = ["languages"]
draft = false
weight = 2000
foo = "bar"
baz = "zoo"
alpha = 1
beta = "two words"
gamma = 10
mathjax = true
[menu.main]
  identifier = "r-lang"
  weight = 2000
+++

## operators {#operators}

Exponent: ^


## difference between = and <- operators {#difference-between-and-operators}


## vectors (range) {#vectors--range}

-   1:9, 1:2:9, c(1,3,2,-8.1)
-   c() for concat


## vector addition {#vector-addition}

-   v1 + v2


## matrices {#matrices}

-   matrix(c(1,2,3,4,5,6,7,8,9), nrow=3)
-   nrow is the number of rows or ncol for number of columns
-   fills in column order, i.e.
    [[1,4,7],[2,5,8],[3,6,9]]


### matrix multiplication {#matrix-multiplication}

-   m1 %\*% m2


### transpose {#transpose}

-   t(m1)


### slicing {#slicing}

-   m1[1,3]
-   m1[,3]  : all elements on third column
-   m1[1,]  : all elements on first rows
-   m1[,-2] : all but the second column
-   m1[1,1] = 15
-   m1[,2:3] = 1    : set columns 2 and 3 to 2
-   m1[,2:3] = 4:9  : set columns 2 and 3 to col2:4,5,6, col3:7,8,9
-   m1[m1>5]        : filter elements in m1 that are greater than 5
-   m1[m1>5] = 3    : set all elements greater than 5 to 3


## loops {#loops}

for(i in 1:3) { print(i) }
while(sum(v1)>=5) {}


## control {#control}

if(m1[i,1]>=2){}


## ternary if {#ternary-if}

ifelse(a==1,1,0)


## types {#types}

class(1)
class(c(1,2))  : numeric
class(1:3)     : integer : more specific, and saves footprint
class(1.1:3)   : numeric
class("hello") : character
class(c("r","g")) : character
class(c(1,"r"))   : character
class(c(T,F))     : logical


## vector {#vector}

vector(mode="logical",3)

-   this class can only contain one type, 'numeric', 'character', or 'logical'


### matrix {#matrix}

is a 2-D 'vector'
class(m1)  : matrix


## array {#array}

-   can only have one data type like vector and matrix
-   arrays can also store matrices, data frames and lists
-   can be multidimensional

array(1:16, dim=c(4,2,2))


## dataframe {#dataframe}

df = data.frame(c(1,2,3),c(T,F,F),row.names=c("r","g","b"))
names(df)[1] = "col1"
names(df)[2] = "col2"


## list {#list}

a = list("a",1",F)
use double [] to access element
a = list(category1=c(1), category2=c(T), category3=c("r"))
a$category1


## hierarchy {#hierarchy}

{{< figure src="/images/rlang/ds-hierarchy.png" >}}


## conversion {#conversion}

as.vector(), as.logical(), as.character
