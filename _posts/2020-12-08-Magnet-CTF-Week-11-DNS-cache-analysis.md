---
layout: single
title: "Magnet CTF Week 11 - DNS Cache Analysis... sort of"
date: '2020-12-22T01:00:00+09:00'
author: "Joshua I. James"
tags:
  - infosec
  - dfir
  - CTF
  - Magnet
modified_time: ""
---

Magnet Forensics is running a *weekly* forensic CTF. More information can be found on their [blog](https://www.magnetforensics.com/blog/magnet-weekly-ctf-challenge/). It is a fun way to practice, so let's get to it!

### CTF Posts

[Week 1](https://dfir.science/2020/10/Magnet-CTF-Week-1-Timestamps-of-doom.html) | [Week 2](https://dfir.science/2020/10/Magnet-CTF-Week-2-URLs-in-Pictures-in-Pictures.html) | [Week 3](https://dfir.science/2020/10/Magnet-CTF-Week-3-Failed-connections.html) | [Week 4](https://dfir.science/2020/11/Magnet-CTF-Week-4-GUIDSWAP-and-drop.html) | [Week 5](https://dfir.science/2020/11/Magnet-CTF-Week-5-HDFS.html) | [Week 6](https://dfir.science/2020/11/Magnet-CTF-Week-6-Riddle-ELF.html) | [Week 7](https://dfir.science/2020/11/Magnet-CTF-Week-7-Hadoop-Nodes.html) | [Week 8](https://dfir.science/2020/12/Magnet-CTF-Week-8-Persistence-in-plain-sight.html) | [Week 9](https://dfir.science/2020/12/Magnet-CTF-Week-9-digging-through-memory.html) | [Week 10](https://dfir.science/2020/12/Magnet-CTF-Week-10-network-analysis-in-RAM.html)

### Getting Started

New image for December! It can be found [here](https://drive.google.com/drive/folders/10fYCrNI46FT9l3LaJ9dj5gLxjlLtdnPo?usp=sharing). This is a memory image, and this week has multiple questions. Note: I may jump between Volatility 2.6 and 3 as I'm playing around.

> Q1: What is the IPv4 address that myaccount.google.com resolves to?

First I pinged myaccount.google.com. I was pretty sure the same resolution would not be it, but it was worth a try. Next, I looked for active connections. I found a few owned by Google, but no indication that they belong to "myaccount".

I looked for a way to extact the DNS cache, but could not find any tool or tip that worked for me. After a long while running down some research leads, I decided to try a search for any Google IP addresses around "myaccount.google.com". Hopefuly this would get me the DNS cache, even if I don't know the structure.

```bash
$ strings memdump-001.0.mem | grep -B 5 -A 5  myaccount | grep 172\.
172.217.12.131
172.217.10.238le.com0
```

In the command above I am using strings on the memory image, and returning 5 rows before and after the hit for "myaccount". Then I search for 172, which is what I guess is the first octet of a Google IP address.

Tried 131, but failed. Trying ```172.217.10.238``` and **BING!** Success.

Really looking forward to the writeup for this question!

> Q2: What is the canonical name (cname) associated with Part 1?

I'm not sure if I did this one as intended, but I queried the current state of Google DNS.

```bash
$ dig myaccount.google.com

;; DiG 9.16.1-Ubuntu myaccount.google.com
;; global options: +cmd
;; Got answer:
;; HEADER opcode: QUERY, status: NOERROR, id: 16677
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1
[SNIP]
ANSWER SECTION:
myaccount.google.com.	2674	IN	CNAME	www3.l.google.com.
www3.l.google.com.	283	IN	A	172.217.31.174
[SNIP]
```

Trying ```www3.l.google.com``` and **BING!** Success.

## Lessons Learned

I spent a lot of time looking for DNS cache in memory and didn't find anything. I tried to look a bit at the structure that was returned during search. This is something I really want to look into more in the future. I'm excited to see what everyone came up with, and maybe there is an easy solution I didn't find.