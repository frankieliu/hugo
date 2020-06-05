+++
title = "Bomb lab"
author = ["adam"]
date = 2020-06-02T12:13:39-07:00
lastmod = 2020-06-03T16:19:46-07:00
tags = ["bomb lab", "assembly", "debugger"]
categories = ["assembly", "debugger"]
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

## sample bomb {#sample-bomb}

<http://csapp.cs.cmu.edu/3e/labs.html>


## name list (nm), strings, objdump {#name-list--nm--strings-objdump}

-   nm bomb
-   strings
-   objdump


## start gdb in gui mode {#start-gdb-in-gui-mode}

gdb -tui bomb

<https://sourceware.org/gdb/current/onlinedocs/gdb/TUI-Keys.html#TUI-Keys>


### Keyboard shortcut {#keyboard-shortcut}

-   C-x a : enter or leave TUI mode
-   C-x 1 : one window
-   C-x 2 : two windows

    also cycles through different layouts

-   C-x o : 'other'
-   C-l   : refresh


#### Navication {#navication}

up, down, left, right, pgup, pgdown

c-p, c-n on the gdb history while in tui mode


#### Single key mode {#single-key-mode}

-   C-x s : single key mode
-   (c) continue
-   (d) down
-   (f) finish
-   (n) next
-   (o) nexti (step over)
-   (q) exit single key mode
-   (r) run
-   (v) info locals
-   (w) where


## getting started {#getting-started}

<https://www.youtube.com/watch?v=-n9Fkq1e6sg>


### source file {#source-file}

`test.c`

```c
#include <stdio.h>

int main() {
  int a = 1;
  int b = 2;
  int c = 3;
  a += b;
  a = a + c;
  printf("Value of a: %d\n",a);
   return 0;
}
```

Compile with `gcc -g test.c`


### gdb {#gdb}

bash
: gdb ./a.out


gdb
: b main

    sets a breakpoint on main


gdb
: info b

    get information about breakpoints


gdb
: info locals

    get information about local context variables


gdb
: disable main


gdb
: delete main


gdb
: list


gdb
: list 1,16

    lists line numbers


gdb
: run


gdb
: disassemble


## registers {#registers}

ebp
: base point stack register

esp
: stack point register


## stepping {#stepping}

gdb
: next

gdb
: nexti

    next instruction, use disass after to see that the instruction point moved to
           the next instruction


gdb
: print a

    prints a variable


gdb
: print &a

    prints the address of a variable


gdb
: x /d $rdb+0x14

    prints the contents in /d digit format for address in register $rdb+offset


gdb
: info reg

    shows all the registers


## stepping into / over {#stepping-into-over}

gdb
: nexti (ni)

    steps 'over' the function call


gdb
: stepi

    steps 'into' the function call

    may want to

    1.  clear the breakpoint on main by delete or d main
    2.  do a list, and
    3.  set a breakpoint at line of function call
    4.  run
    5.  disassemble - you will probably see some instruction before the callq
    6.  nexti to the line containing callq


gdb
: disassemble

    now you are inside the frame's function


gdb
: finish

    to step out of the function


## tui and assembly {#tui-and-assembly}

<https://sourceware.org/gdb/current/onlinedocs/gdb/TUI.html>

gdb
: tui enable


gdb
: layout asm


gdb
: layout reg


gdb
: layout split


gdb
: tui reg float


## shortcuts {#shortcuts}

gdb
: nexti (ni, enter - previous command)


## movement {#movement}

s
: start

    clear all breakpoints and watchpoints


r
: run

n
: next

    goes to next line (step over)


s
: step

    steps into function


c
: continue

    goes till next breakpoint


## breakpoints {#breakpoints}

b
: breakpoint

d
: delete breakpoint

    d with no arguments : deletes all breakpoints


info b


gdb
: b \_exit.c:32 -> normal exit location


## variables {#variables}

p
: print

w
: watch

    whenever variable changes then will break when the variable
    gets a new value


info locals

info args


## view {#view}

l
: list


## x examine {#x-examine}

gdb
: x/20i $pc

    examine 20 instruction at program counter


gdb
: x <variable ptr>

    x without argument will get the next 8 bytes

    x /b will get per byte

    x /10b will get 10 bytes in succession


variables vs pointers
    x <variable> will not work since not passing an address
    x &<variable> will work


## watch points {#watch-points}

rwatch
: watch when variable is read


## stack frame {#stack-frame}

bt
: backtrace

    will see the stack calling frames


frame #
: switch to a particular frame

    can be used to print variables in different frames


## set variable {#set-variable}

-   set var <variable> value


## python {#python}

gdb
: python print(gdb.breakpoints()[0].location)

gdb
: python gdb.Breakpoint('7')

gdb
: python var\_i = gdb.parse\_and\_eval('i')


## command {#command}

<https://github.com/cppcon/cppcon2015>
<https://github.com/cppcon/cppcon2016>
<https://www.youtube.com/watch?v=PorfLSr3DDI>

Lightning Talks and Lunch Sessions / gdb

1.  set breakpoints

    b main

    b \_exit.c:32

2.  command 3

    run

    end

3.  command 2

    record

    continue

    end

4.  this allows you to catch a segfault

    p $pc

    reverse-stepi

    watch when the $sp got changed

    watch **(long \***) 0x14

    reverse-continue
