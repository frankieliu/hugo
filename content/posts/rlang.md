+++
title = "R lang"
author = "adam"
date = 2019-10-04T22:35:02-07:00
lastmod = 2019-10-26T08:12:32-07:00
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
+++

## operators {#operators}

Exponent: ^
Bit: & |
Conditional: && ||


## difference between = and <- operators {#difference-between-and-operators}

Just use =


## vectors (range) {#vectors--range}

-   everything is a vector
-   1:9, 1:2:9, c(1,3,2,-8.1)
-   c() for concat


## vector addition {#vector-addition}

-   v1 + v2 : element wise


## matrices {#matrices}

-   matrix(c(1,2,3,4,5,6,7,8,9), nrow=3)
-   nrow is the number of rows or ncol for number of columns
-   fills in column order, i.e.
    [[1,4,7],[2,5,8],[3,6,9]]
-   matrix(1:9, nrow=3, byrow=T) : fills in row order


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


### NA : Not available (null) {#na-not-available--null}

class(NaN) : numeric
class(NA)  : logical


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


## file system {#file-system}

getwd() : pwd
setwd() : cd
p = read.csv("some.csv", header=TRUE)
row.names(p) = p[,1]
p = p[,-1]
read.delim("filename.xxx", header=TRUE, sep=";', dec=".")

write.csv(var1, file="some.csv")
write.table(df, file="some.csv", sep=" ")
save(var1, var2, file="some.rdata")


## rdata {#rdata}

-   extension: .rdata
-   load("some.rdata")


## plotting {#plotting}

plot(x,y)
x11()    : new window
par(mfrow=c(1,2), bg="grey", bty="n", cex=.75)

-   mfrow : subplot
-   bty : boundary box
-   cex : text ratio

plot(x,y,xlab="1:9", ylab="9:1", main="title", col="red", pch=3)

-   pch : shape of the points

hist(p[,1], main=colnames(p)[1], xlab="xlabel", breaks=c(0,.5,.7,.8,.9,1)
boxplot(p)
lines(x,y)
abline(coef=c(intercept, slope), v=vertical\_x, h=horizontal\_y)
points(1:5,c(4,4,4,4,4), pch=1:5, col=1:5)
par(new=T)
legend(x="topright", legend=c("r","g","b"), lwd=2, col=1:2, bg="grey")

-   lwd : linewidth

pdf("some.pdf")
dev.off()


## help {#help}

?plot


## functions {#functions}

abs(), sqrt()
seq(0,8,2)
rep(c(0,2), 5)
length(c(1,2,3))
system.time((seq1 = seq(0,1e6,1)))
var() : variance
mean(), median()
sample(c(0,1), 10, replace=TRUE, prob = c(.5,.5))
which(vec==1)  : return indices where T
t.test(1:5, 5:10)  : student t-test
runif(5, min=0, max=1)  : random sampling of 5 numbers, unif([0,1])
ls() : what objects are in workspace
rm(var) : remove a variable
q() : quit


### custom functions {#custom-functions}

doublex <- function(x,y=10) { return(2) }dx


## running script from file {#running-script-from-file}

source("some.r")


## Installing packages {#installing-packages}

install.packages("install.load")
library(install.load)
install\_load("somepackage")
library(somepackage)
detach("package:somepackge, unload=TRUE)


## jsonlite {#jsonlite}

install\_load('jsonlite')
a = jsonlite::read\_json('jobj.json')
a$Diameter$mean


## dict package {#dict-package}

if (!require("devtools")) install.packages("devtools")
devtools::install\_github("mkuhn/dict")


## tidyverse {#tidyverse}

Warning messages:
1: In install.packages("tidyverse") :
  installation of package ‘curl’ had non-zero exit status
2: In install.packages("tidyverse") :
  installation of package ‘httr’ had non-zero exit status
3: In install.packages("tidyverse") :
  installation of package ‘rvest’ had non-zero exit status
4: In install.packages("tidyverse") :
  installation of package ‘tidyverse’ had non-zero exit status

sudo aptitude install libcurl4-openssl-dev libxml2-dev
<https://stackoverflow.com/questions/31008877/unable-to-install-rvest-package>


## rss autocomplete {#rss-autocomplete}

<https://ess.r-project.org/Manual/ess.html#Installation>


## tidyverse {#tidyverse}

<https://github.com/tidyverse/stringr>


## r for dummies {#r-for-dummies}

<https://www.dummies.com/programming/r/how-to-combine-logical-statements-in-r/>
