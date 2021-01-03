---
layout: single
title: "Magnet CTF Week 12 - Registry update analysis"
date: '2020-12-29T01:00:00+09:00'
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

[Week 1](https://dfir.science/2020/10/Magnet-CTF-Week-1-Timestamps-of-doom.html) | [Week 2](https://dfir.science/2020/10/Magnet-CTF-Week-2-URLs-in-Pictures-in-Pictures.html) | [Week 3](https://dfir.science/2020/10/Magnet-CTF-Week-3-Failed-connections.html) | [Week 4](https://dfir.science/2020/11/Magnet-CTF-Week-4-GUIDSWAP-and-drop.html) | [Week 5](https://dfir.science/2020/11/Magnet-CTF-Week-5-HDFS.html) | [Week 6](https://dfir.science/2020/11/Magnet-CTF-Week-6-Riddle-ELF.html) | [Week 7](https://dfir.science/2020/11/Magnet-CTF-Week-7-Hadoop-Nodes.html) | [Week 8](https://dfir.science/2020/12/Magnet-CTF-Week-8-Persistence-in-plain-sight.html) | [Week 9](https://dfir.science/2020/12/Magnet-CTF-Week-9-digging-through-memory.html) | [Week 10](https://dfir.science/2020/12/Magnet-CTF-Week-10-network-analysis-in-RAM.html) | [Week 11](https://dfir.science/2020/12/Magnet-CTF-Week-11-DNS-cache-analysis.html)

### Getting Started

New image for December! It can be found [here](https://drive.google.com/drive/folders/10fYCrNI46FT9l3LaJ9dj5gLxjlLtdnPo?usp=sharing). This is a memory image, and this week has multiple questions. Note: I may jump between Volatility 2.6 and 3 as I'm playing around.

> Q1: What is the PID of the application where you might learn "how hackers hack, and how to stop them"? Format: #### Warning: Only 1 attempt allowed!

First I did a strings search over memory for "hacked" with a few lines of context. This returned some BING searches. From past weeks I don't remember any Bing searches in Chrome. Double check Chrome history shows no Bing. So most likely we are dealing with Internet Explorer. 

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 pslist | grep iexplore
Volatility Foundation Volatility Framework 2.6
0xfffffa8032c66060 iexplore.exe           2984   2672     14      514      1      0 2020-04-20 23:18:35 UTC+0000                                 
0xfffffa8031d34a40 iexplore.exe           4480   2984     18      566      1      1 2020-04-20 23:18:35 UTC+0000
```

Two PIDs exist for iexplore. Let's search both PIDs for strings related to hacking.

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 yarascan -Y "hack" -p 2984
Volatility Foundation Volatility Framework 2.6
[SNIP - nothing interesting]
```

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 yarascan -Y "hack" -p 4480
Volatility Foundation Volatility Framework 2.6
Rule: r1
Owner: Process iexplore.exe Pid 4480
0x002fc813  68 61 63 6b 65 64 2b 6f 76 65 72 2b 61 6e 64 2b   hacked+over+and+
0x002fc823  6f 76 65 72 26 73 72 63 3d 49 45 2d 54 6f 70 52   over&src=IE-TopR
0x002fc833  65 73 75 6c 74 26 46 4f 52 4d 3d 49 45 54 52 30   esult&FORM=IETR0
0x002fc843  32 26 63 6f 6e 76 65 72 73 61 74 69 6f 6e 69 64   2&conversationid
0x002fc853  3d 00 00 00 00 fc 37 aa 10 00 00 00 80 77 02 6f   =.....7......w.o
0x002fc863  6b 69 65 3a 20 53 52 43 48 44 3d 41 46 3d 4e 4f   kie:.SRCHD=AF=NO
0x002fc873  46 4f 52 4d 3b 20 53 52 43 48 55 49 44 3d 56 3d   FORM;.SRCHUID=V=
0x002fc883  32 26 47 55 49 44 3d 33 32 41 41 33 42 35 31 37   2&GUID=32AA3B517
0x002fc893  36 30 42 34 41 39 44 38 42 37 36 42 36 36 41 44   60B4A9D8B76B66AD
0x002fc8a3  42 39 41 42 34 37 35 26 64 6d 6e 63 68 67 3d 31   B9AB475&dmnchg=1
0x002fc8b3  3b 20 53 52 43 48 55 53 52 3d 44 4f 42 3d 32 30   ;.SRCHUSR=DOB=20
0x002fc8c3  32 30 30 34 32 30 26 54 3d 31 35 38 37 34 32 34   200420&T=1587424
0x002fc8d3  37 32 35 30 30 30 00 00 00 00 00 00 00 eb 37 aa   725000........7.
0x002fc8e3  10 00 00 00 88 6e 00 00 00 68 00 74 00 74 00 70   .....n...h.t.t.p
0x002fc8f3  00 73 00 3a 00 2f 00 2f 00 77 00 77 00 77 00 2e   .s.:././.w.w.w..
0x002fc903  00 62 00 69 00 6e 00 67 00 2e 00 63 00 6f 00 6d   .b.i.n.g...c.o.m
[SNIP]
```

PID 4480 returned a lot of hits for hacking. Trying PID 4480 and **BING!** Success.

> Q2: What is the product version of the application from Part 1? Format: XX.XX.XXXX.XXXXX

Checking the Windows Registry...

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 printkey -K "Microsoft\Internet Explorer"
Volatility Foundation Volatility Framework 2.6
Legend: (S) = Stable   (V) = Volatile

----------------------------
Registry: \SystemRoot\System32\Config\SOFTWARE
Key name: Internet Explorer (S)
Last updated: 2020-04-20 20:25:57 UTC+0000
[SNIP]

Values:
REG_SZ        MkEnabled       : (S) Yes
REG_SZ        Version         : (S) 9.11.9600.18860
REG_SZ        Build           : (S) 99600
REG_SZ        W2kVersion      : (S) 9.11.9600.18860
REG_DWORD     IntegratedBrowser : (S) 1
REG_SZ        svcKBFWLink     : (S) https://go.microsoft.com/fwlink/?linkid=862372
REG_SZ        svcVersion      : (S) 11.0.9600.18860
REG_SZ        svcUpdateVersion : (S) 11.0.49
REG_SZ        svcKBNumber     : (S) KB4052978
```

The Version and svcVersion are almost the right format, but both are missing one digit. Trying both... fail.

I figured the Registry would be correct, but maybe the executable was updated after execution? So we need to dump the executable from memory. We already have the PID, so we are halfway home.


```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 procdump -D dump/ -p 4480
Volatility Foundation Volatility Framework 2.6
Process(V)         ImageBase          Name                 Result
------------------ ------------------ -------------------- ------
0xfffffa8031d34a40 0x00000000013d0000 iexplore.exe         OK: executable.4480.exe
```

Now we could use fancy tools to reverse the executable, but I'll stick with xxd.

```bash
$ xxd executable.4480.exe | more
[SNIP]
000c2d20: 5800 4500 0000 0000 4400 1200 0100 5000  X.E.....D.....P.
000c2d30: 7200 6f00 6400 7500 6300 7400 4e00 6100  r.o.d.u.c.t.N.a.
000c2d40: 6d00 6500 0000 0000 4900 6e00 7400 6500  m.e.....I.n.t.e.
000c2d50: 7200 6e00 6500 7400 2000 4500 7800 7000  r.n.e.t. .E.x.p.
000c2d60: 6c00 6f00 7200 6500 7200 0000 4600 1100  l.o.r.e.r...F...
000c2d70: 0100 5000 7200 6f00 6400 7500 6300 7400  ..P.r.o.d.u.c.t.
000c2d80: 5600 6500 7200 7300 6900 6f00 6e00 0000  V.e.r.s.i.o.n...
000c2d90: 3100 3100 2e00 3000 3000 2e00 3900 3600  1.1...0.0...9.6.
000c2da0: 3000 3000 2e00 3100 3800 3800 3500 3800  0.0...1.8.8.5.8.
000c2db0: 0000 0000 4400 0000 0100 5600 6100 7200  ....D.....V.a.r.
000c2dc0: 4600 6900 6c00 6500 4900 6e00 6600 6f00  F.i.l.e.I.n.f.o.
000c2dd0: 0000 0000 2400 0400 0000 5400 7200 6100  ....$.....T.r.a.
000c2de0: 6e00 7300 6c00 6100 7400 6900 6f00 6e00  n.s.l.a.t.i.o.n.
[SNIP]
```

Near the end of the binary we can see the product version in the correct format. The minor version is 18858 so it was updated after execution. Trying 11.00.9600.18858 and **BING!** Success!

## Lessons Learned

I wanted to dump the executable first, but I felt too lazy to try to reverse it. Instead I thought "oh everything is recorded in the Registry anyway." Well, the Registry is close, but actually slightly higer version than the loaded executable. Lesson learned - always dump the executable.

This was the final week for the Magnet Weekly CTF. It was SO FUN! I like the slow pace and hard problems each week. I learned so much through this. Thanks so much to [Magnet Forensics](https://www.magnetforensics.com/) for hosting this!