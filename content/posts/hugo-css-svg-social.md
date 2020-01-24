+++
title = "Hugo: custom css, social-follow, svg, baseurl, comments"
author = ["adam"]
date = 2020-01-23T14:50:02-08:00
lastmod = 2020-01-23T16:30:43-08:00
tags = ["hugo", "github-pages", "ananke"]
categories = ["hugo", "github-pages"]
draft = false
weight = 2000
foo = "bar"
baz = "zoo"
alpha = 1
beta = "two words"
gamma = 10
mathjax = true
+++

## hugo social buttons {#hugo-social-buttons}

It stated with wanting to add social buttons on my web page.  This was as easy
as changing the config.toml file.  For Ananke theme, it is looking for some
parameters, in the `[params]` sections.  Just add you link to facebook, twitter,
etc as `facebook = "https://www.facebook.com/ID"`.


## case of missing id {#case-of-missing-id}

I was upset that it had a slack link available, but no discord one.  One because
I don't even know what is one's slack id.  There are so many workspaces in
slack.  And each workspace may have an id associated with it.  The cleanest
thing to do seems to create a slack workspace and then go to your profile and
then get the copy your id.  Then it is pretty non-intuitive from there.  You use
your group name such as WORKSPACE.slack.com/team/ID.  The only way I found out
about this was through this obscure website:

[link](https://slack.com/help/articles/360003827751-Create-a-link-to-a-members-profile-)

Honestly I never been happy with Slack, this being only the tick of the iceberg.

Not that I had a brillant way to do this in discord, you have to turn on a
developer setting in discord to be able to click on a user and copy their id.
And like slack, once you get the user id, what do you do with it.  Luckily with
discord it is just one central repository so it looks like
discordapp.com/users/ID.  I can take that, much better than slack.


## where to add discord {#where-to-add-discord}

I then did a quick search in ananke looking for facebook, and it landed me in
the layout/partials/social-follow.html from there you copy and paste from one of
the existing ones and add a logo which goes into the svg directory.

Note that every icon has a class associated with it.  We will return to this in
a second.

I googled discord blanding and found ready made svg's.  Way to go discord!

I put the symbol in the svg directory and updated the social-follow.html
template with the appropriate svg file and crossed my fingers.

Long story short, didn't work.

1.  because the svg's in the directory are templated.  Okay, I copied the
    template and voila, nothing happened.
2.  I then copied the medium svg just to see if there was something wrong with
    the svg from discord.  Nope that didn't work.
3.  it turns out that the problem was in the coloring of the icon using a css
    file.


### notes {#notes}

I did Shift-J in chrome to check if the icons were at fault. After templating
maybe the discord.svg didn't get the right values... No not the case


## a tale of css {#a-tale-of-css}

Poking around more in the ananke directory, I found a css for facebook and other
social follows in src/css.  It was being included by main.css.

\_social-follow.css actually contained the css class elements that I was looking
for.  I added the a discord class definition, and looked up discord's color,
again thanks to discord blanding website, the 3-tuple was already there for the
taking.

Note because I don't change anything in the ananke theme directory you need to
usually make a copy of the hierarchy in the hugo base.  For example for
social-follow.html and svg one just copies the it into a similar one in
layouts/partials under hugo and puts the svg in that directory as well, since we
are working off social-follow.html I also had to copy the whole svg directory
over with the added discord.svg.   Note that I had to move the discord path a
bit because it wasn't centered and was not as small as the one used by ananke.

The problem is how to replace the css files, since they are not used by hugo in
the same way.  Googling around found that there are options for including one's
own css.  I looked for custom\_css in ananke and found that
layouts/\_default/baseof.html it is as simple as adding a custom\_css parameter in
config.toml and pointing it at a file that can accessed by hugo.

For such files, I usually put them in the static/ directory, keeping simple
convensions I started a static/css directory and added the \_social-icons.css.
Lo and behold everything looked fine in the local server, but somehow the css
was not being picked up from github pages.

Sure enough the directory css/\_social-icons.css was created, but wasn't somehow
being picked up.  I had a similar issue before with images, because I am using
namecheap as my nameserver provider and I include the requesite CNAME in the
github repo, and in general set the baseURL with the correct relative location
for github project gh-pages, i.e. <https://mydomain/PROJECT/> .  I canonifyURLs so
that the full path is usually being used.

I forcefully tried many variations in adding a slash in front of the
/css/\_social-icons.css and removing relURL ($.Site.BaseURL) altogether
none of these seemed to make any difference.

TL;DR story is that the underscore in the css file name indicates that it is
to be imported by some other css file, therefore the server does not server
css files with underscores in front of css file names.  I changed to it a
non-underscore name and voila it worked.


## comments {#comments}

Now that I was in a row I decided to add a comment system.  There ia a very cool
work called utterances.es which allows one to post comments as github issues.
The instructions in the site are pretty minimal, you have to add utterances api
to the relevant github repo, then just add the javascript at the bottom of
layouts/\_default/single.html.  The only caveat is that one has to login with
their github account.  Most people probably already have a github account so it
should be work pretty much everywhere.
