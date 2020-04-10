+++
title = "Discord: creating a bot"
author = ["adam"]
date = 2020-04-09T15:12:31-07:00
lastmod = 2020-04-09T17:42:44-07:00
tags = ["discord", "bot"]
categories = ["discord", "bot"]
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

## Creating a bot on discord {#creating-a-bot-on-discord}

While there are some samples in discord.py.  The API is fairly flat and hard to
navigate.

Here are the links to getting started:

[commands](https://discordpy.readthedocs.io/en/latest/ext/commands/commands.html)


## Understanding the context {#understanding-the-context}

The Context (ctx) is often the first argument in the functions from @bot.command.
This ctx contains most of the things needed to identify the message triggering
the robot to respond (ctx fields):

-   guild - on which server the robot was triggered
-   message - the message of the command
-   author - the author of the message
-   send() - a function that allows the robot to respond back as a response to the trigger

From this it is obvious you need some other way of getting at the channel where
the message was sent.  Fortunately many of the things you need are actually
included in ctx.message.

In particular, ctx.message.channel points to the originating channel.

But if you wanted to get a list of all the channels in the server you would be
looking at them in ctx.guild.channels, and you could also get all the members of
the server with ctx.guild.members, or if looking for a particular user use
ctx.guild.get\_member\_named, whch allows you to find by name or
name#discriminator where the discriminator is a 4 digit number.


## Webhook {#webhook}

It is possible to create webhooks from a particular channel, this webhook is
essential in that it allows a send() inclusing a username and avatar\_url.  This
comes in handy when moving a message from one channel to another channel.


## Message {#message}

Given a messageId, it is possible to fetch a message in a particular channel.
There are a few fields that are particularly useful:

-   content
-   author
-   embeds
-   attachments
-   created\_at
-   edited\_at


## Mention {#mention}

The string in the message content that signifies a mention has the following
format:

<@!{author.id}>

This can be compared with the usual tag which is

{author.name}#{author.discriminator}

Note that author.mention doesn't contain the exclamation mark.


## Avatar {#avatar}

The avatars are stored in a cdn and can be obtained from author.avatar\_url


## Python types {#python-types}

Union and Optional type hints.

[stackoverflow](https://stackoverflow.com/questions/51710037/how-should-i-use-the-optional-type-hint)


## full implementation {#full-implementation}

```python
import discord
from discord.ext import commands
import random


description = """An example bot"""
bot=commands.Bot(command_prefix='?', description=description)

@bot.event
async def on_ready():
    print("We have logged in as {0.name} {0.id}".format(bot.user))

@bot.command()
async def roll(ctx, dice: str):
    try:
        rolls, limit = map(int, dice.split('d'))
    except Exception:
        await ctx.send('Format has to be in NdN!')
        return
    result = ", ".join(str(random.randint(1,limit)) for r in range(rolls))
    await ctx.send(result)

@bot.command()
async def mv(ctx, messageId, toChannelName, *kargs):
    # Transform some of the kargs
    opts = dict()
    for x in kargs:
        if x.find('=') != -1:
            k,v = x.split('=')
            opts[k] = v

    # get the channel from where the message originated
    print("Guild:", ctx.guild.name,
          ", Channel:", ctx.message.channel.name,
          ", Command: mv")

    # fromChannel
    fromChannel = ctx.message.channel

    # finds the destination channel and gets a webhook
    tChan = [x for x in ctx.guild.channels if x.name == toChannelName]
    if len(tChan) == 0: return
    toChannel = tChan[0]
    wbs = await toChannel.webhooks()
    if len(wbs) < 1:
        wb = await toChannel.create_webhook(name='Move message')
    else:
        wb = wbs[0]

    # gets the original message
    message = await fromChannel.fetch_message(messageId)

    print("Moving message...")
    print("Author: {0.name} {0.discriminator} {0.id} {0.mention} {0.avatar_url}".format(message.author))
    print("Embeds:", message.embeds)
    print("Attachments:", message.attachments)
    print("Content:", message.content)

    # Used to assign a different author using the from= option
    author = message.author
    if 'from' in opts:
        fauthor = ctx.guild.get_member_named(opts['from'])
        if fauthor is not None:
            print("Setting author to {0.name}.".format(fauthor))
            author = fauthor

    # Create a header for message being moved
    mention = "From <@!{}>, ".format(author.id)
    if message.edited_at:
        msgtime = "edited at {}.\n\n".format(message.edited_at)
    else:
        msgtime = "created at {}.\n\n".format(message.created_at)
    tag = "{0.name}#{0.discriminator}".format(author)

    # Sending to other channel
    await wb.send(content=mention+msgtime+message.content,
                  username=tag,
                  avatar_url=author.avatar_url,
                  tts=False,
                  embeds=message.embeds,
                  files=message.attachments)

bot.run(bot_token)
```
