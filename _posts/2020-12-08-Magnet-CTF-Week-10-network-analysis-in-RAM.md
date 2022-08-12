---
layout: single
title: "Magnet CTF Week 10 - Network analysis in RAM"
date: '2020-12-15T01:00:00+09:00'

tags:
  - infosec
  - dfir
  - CTF
  - Magnet
modified_time: ""
---

Magnet Forensics is running a *weekly* forensic CTF. More information can be found on their [blog](https://www.magnetforensics.com/blog/magnet-weekly-ctf-challenge/). It is a fun way to practice, so let's get to it!

### CTF Posts

[Week 1](https://dfir.science/2020/10/Magnet-CTF-Week-1-Timestamps-of-doom.html) | [Week 2](https://dfir.science/2020/10/Magnet-CTF-Week-2-URLs-in-Pictures-in-Pictures.html) | [Week 3](https://dfir.science/2020/10/Magnet-CTF-Week-3-Failed-connections.html) | [Week 4](https://dfir.science/2020/11/Magnet-CTF-Week-4-GUIDSWAP-and-drop.html) | [Week 5](https://dfir.science/2020/11/Magnet-CTF-Week-5-HDFS.html) | [Week 6](https://dfir.science/2020/11/Magnet-CTF-Week-6-Riddle-ELF.html) | [Week 7](https://dfir.science/2020/11/Magnet-CTF-Week-7-Hadoop-Nodes.html) | [Week 8](https://dfir.science/2020/12/Magnet-CTF-Week-8-Persistence-in-plain-sight.html) | [Week 9](https://dfir.science/2020/12/Magnet-CTF-Week-9-digging-through-memory.html)

### Getting Started

New image for December! It can be found [here](https://drive.google.com/drive/folders/10fYCrNI46FT9l3LaJ9dj5gLxjlLtdnPo?usp=sharing). This is a memory image, and this week has multiple questions. Note: I may jump between Volatility 2.6 and 3 as I'm playing around.

> Q1: *At the time of the RAM collection (20-Apr-20 23:23:26- Imageinfo) there was an established connection to a Google Server. What was the Remote IP address and port number? format: "xxx.xxx.xx.xxx:xxx"

The IP format gives a bit of a hint. We know the third octet is two digits and the rest are three. The port is also (probably) 443 since it's def not 80. Let's use Volatility to check the established connections (at the time of imaging).

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 netscan | grep -i established
Volatility Foundation Volatility Framework 2.6
0x13d48f540        TCPv4    192.168.10.146:54279           151.101.116.106:443  ESTABLISHED      -1                      
0x13ec87cd0        TCPv4    192.168.10.146:54282           172.253.63.188:443   ESTABLISHED      -1                      
0x13ece73b0        TCPv4    192.168.10.146:54281           13.35.82.31:443      ESTABLISHED      -1                      
0x13ecf8010        TCPv4    192.168.10.146:54280           13.35.82.102:443     ESTABLISHED      -1     
```

Lucky for us only one Google IP address is listed, and it is in the correct format. Trying ```172.253.63.188:443``` and **BING!** Success.

> Q2: What was the Local IP address and port number? same format as part 1

In the prior command, the number on the right is the public IP the system is connecting to. The number on the left (starting with 192.168) is the *private* (local) IP address of the system. Trying ```192.168.10.146:54282``` and **BING!** Success.

> Q3: What was the URL?

First, check for a browser process and get it's ID. I bet it is Chrome. 

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 pslist | grep -i chrome
Volatility Foundation Volatility Framework 2.6
0xfffffa8031e2c2c0 chrome.exe             3384   2672     30     1039      1      0 2020-04-20 23:17:07 UTC+0000                                 
0xfffffa8032429060 chrome.exe             3392   3384      7       95      1      0 2020-04-20 23:17:07 UTC+0000                                 
0xfffffa80324ca5c0 chrome.exe             3492   3384      2       56      1      0 2020-04-20 23:17:09 UTC+0000
```

The PID we are interested in is ```3384```. We want to dump the history file from the Chrome process.

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 dumpfiles -D dump/ -r History$ -i -p 3384
Volatility Foundation Volatility Framework 2.6
DataSectionObject 0xfffffa80325ccb30   3384   \Device\HarddiskVolume1\Users\Warren\AppData\Local\Google\Chrome\User Data\Default\History
SharedCacheMap 0xfffffa80325ccb30   3384   \Device\HarddiskVolume1\Users\Warren\AppData\Local\Google\Chrome\User Data\Default\History
```

This gives us ```file.3384.0xfffffa80311c7eb0.dat```. If we open that with an SQLite viewer, go to the ```URLs``` table, sort by ```last_visit_time```, and you will see https://google.com. Trying, and **BING!** Success.

> Q4: What user was responsible for this activity based on the profile?

We can see in the previous command that the user account appears to be "Warren", but just to check let's look at the hashdump.

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 hashdump
Volatility Foundation Volatility Framework 2.6
Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
**Warren**:1000:aad3b435b51404eeaad3b435b51404ee:2aa81fb8c8cdfd8f420f7f94615036b0:::
```

Confirmed. Trying "Warren" and **BING!** Success.

> Q5: How long was this user looking at this browser with this version of Chrome?

This question was quite nasty. I kept thinking about prefetch timelines, but didn't think of a way to find the exact time viewed. I tried building process execution timelines, but that wasn't it. I turned to the Windows Registry. After a lot of hacking around I figured it must be UserAssist.

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 userassist | grep -A 4 -i Chrome
Volatility Foundation Volatility Framework 2.6
REG_BINARY    Chrome          : 
Count:          9
Focus Count:    106
Time Focused:   3:36:47.301000
Last updated:   2020-04-20 23:17:07 UTC+0000
--
REG_BINARY    %APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Google Chrome.lnk : 
Count:          7
Focus Count:    0
Time Focused:   0:00:00.507000
Last updated:   2020-04-20 23:17:07 UTC+0000
--
REG_BINARY    C:\Users\Public\Desktop\Google Chrome.lnk : 
Count:          2
Focus Count:    0
Time Focused:   0:00:00.502000
Last updated:   2020-02-18 07:43:29 UTC+0000
```

We are interested in the first entry. Specifically, ```Time Focused:   3:36:47.301000```. Trying and **BING!** Success (finally).

## Lessons Learned

I've leared a lot every week of the Magnet CTF. However, memory analysis has really pushed me. I look at a question and think "dang I know where that is on disk, how am I going to carve it?" For some reason I keep wanting to default to "carve." The curve-ball this week was Registry analysis from memory. It's extremely useful, and I'm sure I will use it again. 