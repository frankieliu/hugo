+++
title = "Ascii Diagrams"
author = ["adam"]
date = 2020-04-29T11:37:40-07:00
lastmod = 2020-04-29T12:09:16-07:00
tags = ["ascii", "diagrams"]
categories = ["ascii", "diagrams"]
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

## Asciio {#asciio}


### Modifications {#modifications}

-   clone P5-App-Asciio
-   change the zoom in and zoom out keys

./setup/actions/unsorted.pl:	'Zoom in' => ['000-plus', \\&zoom, 1]


### Building prep {#building-prep}

perl Build.PL


### Dependencies {#dependencies}

In Ubuntu most dependencies can be resolved by

```bash
sudo aptitude install lib<Module>-<Submodule>-perl
```

For example if the dependencies require \`Foo::Bar\`, install it with
\`sudo aptitude install libfoo-bar-perl\`

Hash::Slice unfortunately is not part of Ubuntu distribution so you will have to
install it via CPAN

```bash
cpan Hash::Slice
```


### Building {#building}

```bash
./Build
./Build test
sudo ./Build install
```


### Changed file: {#changed-file}

```perl
(
 'Zoom in' => ['000-KP_Add', \&zoom, 1],
 'Zoom in' => ['00S-plus', \&zoom, 1],
 'Zoom out' => ['000-KP_Subtract', \&zoom, -1],
 'Zoom out' => ['000-minus', \&zoom, -1],
)
```

Note that the latter ones overwrite previous ones.
