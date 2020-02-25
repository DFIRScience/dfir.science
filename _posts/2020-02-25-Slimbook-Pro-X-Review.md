---
layout: single
title: "Slimbook Pro X Review"
date: '2020-02-25T09:18:55+09:00'
author: "Joshua I. James"
tags:
  - review
  - Linux
modified_time: ""
---

This post is a review of the [Slimbook Pro X](https://slimbook.es/en/pro-x-en). I've been using
the Slimbook for about a month. There isn't much info available in English, so I thought I would
do a review. If you just want to see the review, [skip the backstory](#review).

## Backstory
I travel a lot. I also regularly work with large amounts of data. It's challenging to find
a laptop that has enough power to do what you want, but you can also easily take it anywhere.

I've flirted with something like the MS Surface Pro, but I'm a Linux guy at heart. Sometime
around 2013 - with portability and power in mind - I bought a 17" MSI Stealth. It was powerful
and thin, but very wide (of course) and too heavy for everyday travel. Having a slim laptop didn't
really help since the charger was huge.

I carried the MSI to a few countries. Showing demos and giving presentations was excellent. But
it was too big to do work on during flights. It was a great computer. When the battery no longer
held a charge, it needed to be plugged in all the time. So, it became a desktop PC.

After that, I tried a super-portable MS Surface (not pro). I thought it could charge with a normal
USB connector - no. I thought it could possibly run Linux - no. I was able to write and do some coding on
flights, but demos during training was out of the question. Win10 updates took a very long time,
and I was never sure if I would be able to use the system when I needed to (DoS by update during training).

In 2018, I was given a second-hand, 2010-ish Macbook Air. It was small and relatively light. I slapped
Linux Mint on and everything worked great 'out of the box.' It became my travel laptop. It worked great.
The keyboard was great to type on. I found myself using the MSI as a desktop at work, and the MBA for
almost everything else.

At the end of 2019, the MBA couldn't keep up with some of the projects I was working on. Mint 19.1/2 didn't
support some components (19.3 did, and ended up working better than ever). I decided to consolidate.

I've been using Linux for years now and didn't really care for the MS experience I had with the Surface.
There are quite a few vendors that support Linux as a base now. There are a few companies for Linux-installed
laptops: [Slimbook](https://slimbook.es/en), [System76](https://system76.com/),
[Purism](https://puri.sm), [Dell](https://www.dell.com/en-us/work/shop/overview/cp/linuxsystems), [Compulab](https://fit-iot.com), etc.

### Why Slimbook
Most offer some type of "ultraportable." The Slimbook Pro X caught my attention because of its 14-inch screen in a
13-inch laptop housing. A bit smaller and lighter than the 2010 MBA, but with a bigger display and a lot more power.

Similar spec systems with the other companies were usually more expensive, heavier and with a smaller display.

<span id="review"></span>
## Slimbook Pro X Review

The Slimbook Pro X only comes with a charger and a small pamplet about the system.

![Slimbook Pro X and accessories](assets/images/slimbook/all.jpg)

My first impression when it's closed is that it is quite small. You can see from the pictures below that it is slightly
smaller than the MBA. However, when you open it, it feels big.

![Slimbook Pro X open view](assets/images/slimbook/open.jpg)

The device itself is lighter than the 2010 MBA. The MBA feels a bit more robust, but
the Pro X is not flimsy. However, I wouldn't try to put pressure on the back of the display.

![Slimbook Pro X size comparison with a Macbook Air](assets/images/slimbook/size.jpg)
![Slimbook Pro X size comparison with a Macbook Air](assets/images/slimbook/top.jpg)
![Slimbook Pro X size comparison with a Macbook Air](assets/images/slimbook/size2.jpg)
![Slimbook Pro X size comparison with a Macbook Air](assets/images/slimbook/size3.jpg)

The Slimbook sits higher than it's frame measurement because of risers on the bottom. The fan vents are on the bottom.

### Usage
Once I received the Slimbook, I turned it on to find a Linux Mint OEM install (that I requested). The Slimbook
came pre-installed with company software; Battery, Face, Gestures, and Essentials. Everything worked well on startup.

So, of course, I reformatted. Secure boot and FDE was not enabled (that I remember), and even if it was, I'd rather
do it myself.

Linux Mint 19.3 installed with no issues, except... wifi. I installed Linux firmware ```sudo apt install linux-firmware```
and wifi was supported. At this time I have to hold kernel updates back to 5.3.0-28 until there is a firmware upgrade.

Slimbook software for the Pro X is, apparently, still in testing. Some software is not available in their software channels
or direct downloads. I had to contact support to get access.

Installing Slimbook utilities was mostly painless. Some tools are only available in Spanish, but they are easy to figure out.

So far, all utilities are working as expected. The fan hardly spins up, even with multiple virtual machines running at
the same time. I ran hashcat in brute-force mode and had results comparable to one of my servers. The body did heat up, but
dispersal was good. Inside temp never got hot enough to stop the process.

When on battery, I put it Slimbook's 'Energy Saving' mode. This mode, with wifi, enabled and running Libre Office, gets me about
4-ish hours of life. I've not tried it without wifi, but I expect around 5 or 6 hours. This is *about* what they claim on their
site. 11 hours (doing nothing?), 6 to 8 with office use. Note that I got the 32GB RAM option. I bet that reduces battery life
quite a bit.

One thing I really liked about the MBA was the keyboard. The Slimbook keys have less traction, but they are big, responsive, 
and stable. The keyboard is comfortable to work on for long periods.
 
## Conclusions
Slimbook positions the Pro X as a Macbook Air competitor. I see it more as a Macbook Pro 13 competitor. Think of it like a Macbook Pro in the body of a Macbook Air. It definitely does the job. The overall spec is similar, if not greater. The display is large and sharp. So far, it has handled every major processing task I've thrown at it. The battery capacity is "normal." The power supply is one of the smallest I've seen.

**Overall:** It was well worth the money.

### Things to consider
So far, I don't have any complaints about the Slimbook Pro X. There are some things you may want to consider:

* Applications and support documents are mostly in Spanish.
* The company is small. Their docs are strict about returns and warranty. Not sure what that process is like.
* I contacted support for Slimbook software downloads. They were quick to respond (1 day). It felt like talking to a friend instead of a company.