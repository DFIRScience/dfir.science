---
layout: single
title: "HFS+ Header trivia"
date: '2020-10-16T23:36:15+09:00'
author: "Joshua I. James"
tags:
  - infosec
  - dfir
  - CTF
modified_time: ""
---

In the wee hours of Friday night, just as I was tucked in and toasty, Magnet Weekly CTF dropped a 10 point trivia question. I jumped to answer it like a kid on Christmas day...

I'll just put the **lessons learned** first today: always verify the details, even if you're in a hurry.

So let's see what this tricky business is all about.

> What is the volume header (in hex) of an HFS+ journaled, case-sensitive file system? You have one chance.

Right, so I ran down to the local [Digital Corpora](http://downloads.digitalcorpora.org/corpora/drives/nps-2009-hfsjtest1/)
that just so happens to have an HFS+ image. A little *TCP magic*, and you got yourself an image. Let's take a look.

I assume everyone is using Linux, because WHY NOT? If so, ```xxd``` is built right in.

```bash
$ xxd image.gen0.dmg | more
00000400: 482b 0004 0000 2100 4846 534a 0000 0002  H+....!.HFSJ....
00000410: c5a7 286a c5a7 98f0 0000 0000 c5a7 98ea  ..(j............
00000420: 0000 0006 0000 0004 0000 1000 0000 0a00  ................
00000430: 0000 01bc 0000 090a 0001 0000 0001 0000  ................
00000440: 0000 001b 0000 0007 0000 0000 0000 0001  ................
```

Here we see offset 400 the value ```0x482b```. Checking [this post](http://dubeyko.com/development/FileSystems/HFSPLUS/hexdumps/hfsplus_volume_header.html#attributes), the first two bytes are the *signature* for HFS+. So we have the volume signature! BAM? **NOPE!**

So, what happened. We know it's HFS+. It's definitely the volume header. Taking a look at the [attributes](http://dubeyko.com/development/FileSystems/HFSPLUS/hexdumps/hfsplus_volume_header.html#attributes) section, we can see the *JournaledBit* attribute. But that doesn't seem like what we want.

*Wait a minute.* What's this "case-sensitive" business all about? Isn't HFS+ case-sensitive by default? Nope!

Digital Corpora doesn't seem to have an HFS+ journaled, case-sensitive image, so let's make one.

First, create an empty (1 Meg) container that we can install the file-system on:

```bash
$ dd if=/dev/zero of=test.dmg bs=1 count=0 seek=1M
```

Next, ```mkfs``` supports HFS+ - cool! The ```-s``` switch means case-sensitive. The ```-J``` switch means journaled. 0 here is the size of the journal (we don't care what size for this test).

```bash
$ mkfs.hfsplus -sJ 0 test.dmg
mkfs.hfsplus: journal size 0k too small.  Reset to 8192k.
Initialized test.dmg as a 1024 KB HFS Plus volume with a 8192k journal
```

Now we have an HFS+ volume ready to analyze.

```bash
$ xxd test.dmg | more
00000400: 4858 0005 0000 2100 3130 2e30 0000 0002  HX....!.10.0....
00000410: dbaf 66ac dbaf 66ac 0000 0000 dbaf 66ac  ..f...f.......f.
00000420: 0000 0002 0000 0000 0000 1000 0000 0814  ................
00000430: ffff fff0 0000 08c3 0001 0000 0001 0000  ................
00000440: 0000 0012 0000 0000 0000 0000 0000 0001  ................
```

Well, that looks a bit different! Now we see the first two bytes are ```0x4858``` instead of ```0x482b```.
What does this mean? It means that case-sensitive, journaled HFS+ volumes are registered as HFSX volumes.
If we look at offset 404, we see a value of "5." Previously, the value was "4". This is the volume version.

I don't see anything in the documentation about a "case-sensitive" attribute. So - for now, at least - I'm going
to **assume** (read, IDK) that HFSX (HX header) is always an indicator of case-sensitivity. Both volumes were journaled, so it
*seems* like that's the main difference. Further research necessary.

So, I sent ```HX - 0x4858``` to the judges just to confirm, and **BING!**