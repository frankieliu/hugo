+++
title = "Starting hugo from scratch"
author = ["adam"]
date = 2019-11-05T19:03:13-08:00
lastmod = 2019-11-05T19:48:51-08:00
tags = ["hugo", "deeplearningbook", "github.io"]
categories = ["hugo"]
draft = false
weight = 2000
foo = "bar"
baz = "zoo"
alpha = 1
beta = "two words"
gamma = 10
mathjax = true
+++

## deploying hugo to github.io {#deploying-hugo-to-github-dot-io}

There are a number of ways of doing this. Since I like to keep a separate branch
for the deployment, I opted for the option below. Another option would be use a
docs directory and add to config.toml a line with publishDir = "docs". This
would also work, and you then just need to work on master branch.

This method of maintaining a separate branch is made easier with a worktree that
directly writes to a public folder in gh-pages from the master branch.  But it
requires going to the public folder for staging and committing.

```bash
# initializing a repository
rm -rf dlbook-ig/                    # starting from scratch
hugo new site dlbook-ig              # hugo needs an empty directory, so do hugo first then git init
cd dlbook-ig/
git init                             # starting a local repo
git add .                            # add all files (only arch.. and config.toml)
git commit -m"Init"
hub create -d "Reading of Deep Learning book"     # use hub to create a repo in github
git push origin master

# Setting up gh-pages branch
git checkout --orphan gh-pages       # begin a new branch
git reset --hard                     # remove everything
:                                    # adding themes/ananke in master makes this difficult
:                                    # therefore create gh-pages branch
git commit --allow-empty -m"Init"    # commit it
git push origin gh-pages             # note hugo says push upstream but since this is your
:                                    # own remote repo, seems like origin should be used

# Setting up the public directory to point to gh-pages
git checkout master
git worktree add -B gh-pages public origin/gh-pages
echo "public" >> .gitignore          # static pages will be part of a git worktree
git add .gitignore
git commit -m"ignore public"

# adding some content
git submodule add https://github.com/budparr/gohugo-theme-ananke.git themes/ananke
echo 'theme = "ananke"' >> config.toml
hugo new posts/my-first-post.md
vim content/posts/my-first-post.md   # change draft = false
hugo server -D                       # check w local server
vim config.toml                      # here add baseURL = "http://frankliu.org/dlbook-ig"
hugo -D                              # generate the public directory
git status
git add .
git commit -m"config and first"
git push origin master

# deploy to gh-pages
cd public/
git status
git add .
git commit -m"test"
git push
```


## some helpers {#some-helpers}

```bash

#!/bin/sh

if [ "`git status -s`" ]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo
```

```makefile
.PHONY: server deploy

server:
  xdg-open "http://localhost:1313/hugo/"
  hugo server -D

deploy:
  git add -A
  git commit -m"Adding content"
  git push
  ./publish-to-ghpages.sh
```


## ignore modifications to theme {#ignore-modifications-to-theme}

```conf
[submodule "themes/ananke"]
  path = themes/ananke
  url = https://github.com/budparr/gohugo-theme-ananke.git
  ignore = dirty
```


## some more speciallized additions to config.toml {#some-more-speciallized-additions-to-config-dot-toml}

```conf
baseURL = "https://www.frankliu.org/dlbook-ig/"
# relativeURLs = true
# uglyURLs = true
languageCode = "en-us"
title = "My New Hugo Site"
theme = "ananke"
pygmentsCodeFences = true
# pygmentsUseClasses = true
# pygmentsUseClassic = false
canonifyURLs = true
SectionPagesMenu = "main"

```
