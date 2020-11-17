---
layout: single
title: "Magnet CTF Week 6 - Riddle ELFs"
date: '2020-11-17T13:00:00+09:00'
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

[Week 1](https://dfir.science/2020/10/Magnet-CTF-Week-1-Timestamps-of-doom.html) | [Week 2](https://dfir.science/2020/10/Magnet-CTF-Week-2-URLs-in-Pictures-in-Pictures.html) | [Week 3](https://dfir.science/2020/10/Magnet-CTF-Week-3-Failed-connections.html) | [Week 4](https://dfir.science/2020/11/Magnet-CTF-Week-4-GUIDSWAP-and-drop.html) | [Week 5](https://dfir.science/2020/11/Magnet-CTF-Week-5-HDFS.html)

### Getting Started

Download the images from [Archive.org](https://archive.org/details/Case2-HDFS).

Week 6 question:
This week will be a 2 part question. Each part completed will earn you points!

> Part One: Hadoop is a complex framework from Apache used to perform distributed processing of large data sets. Like most frameworks, it relies on many dependencies to run smoothly. Fortunately, it's designed to install all of these dependencies automatically. On the secondary nodes (not the MAIN node) your colleague recollects seeing one particular dependency failed to install correctly. Your task is to find the specific error code that led to this failed dependency installation. [Flag is numeric]

### Question one

From last week we know that the system is Ubuntu. After a quick look, it looks like both non-primary images were cloned from each other after setup. In Ubuntu, we tend to use APT to install packages. Sometimes dependencies fail. In that case, we are probably interested in an APT log. Linux logs are usually kept in ```/var/log/```. This is a great place to check first.

```bash
$ fls -Fpro 2048 HDFS-Slave1.E01 | grep var/log/apt/
r/r 3671014:  var/log/apt/history.log
r/r 3670038:  var/log/apt/term.log
```

Using ```FLS``` we list files, and filter for the ```var/log/apt``` directory using ```grep```. We can then use ```icat`` to list the contents of the file given the block. For example, the file at block 3670038 "term.log" looks interesting.

```bash
$ icat -o 2048 HDFS-Slave1.E01 3670038 | more
<!--snip-->
Log started: 2017-11-08  01:50:07
Setting up oracle-java7-installer (7u80+7u60arm-0~webupd8~1) ...
Downloading Oracle Java 7...
--2017-11-08 01:50:07--  http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz
Resolving download.oracle.com (download.oracle.com)... 151.248.100.43, 151.248.100.33
Connecting to download.oracle.com (download.oracle.com)|151.248.100.43|:80... connected.
HTTP request sent, awaiting response... 302 Moved Temporarily
Location: https://edelivery.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz [following]
--2017-11-08 01:50:17--  https://edelivery.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz
Resolving edelivery.oracle.com (edelivery.oracle.com)... 104.117.142.224, 2a02:26f0:c00:48f::2d3e, 2a02:26f0:c00:4bd::2d3e
Connecting to edelivery.oracle.com (edelivery.oracle.com)|104.117.142.224|:443... connected.
HTTP request sent, awaiting response... 302 Moved Temporarily
Location: http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz?AuthParam=1510098741_f9941383709eb00c84f24bce765baa81 [following]
--2017-11-08 01:50:20--  http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz?AuthParam=1510098741_f9941383709eb00c84f24bce765baa81
Connecting to download.oracle.com (download.oracle.com)|151.248.100.43|:80... connected.
HTTP request sent, awaiting response... 404 Not Found
2017-11-08 01:50:22 ERROR 404: Not Found.
<!--snip-->
```

Looking at the contents of term.log we can see that APT tried to download Java JDK, but could not connect. What's that at the end? ```ERROR 404: Not Found```.

Let's try "404" as the error code. **BING!**

### Question two

This week was a two-parter. The first question was pretty straightforward. The second is a bit more Riddler.

> Don't panic about the failed dependency installation. A very closely related dependency did end up getting installed successfully. Where did it land? Amongst its nearby on-and-off friends, this particular file seems rather an ELFant. Using the error code from your first task, search out offsets beginning with the same number. There are three in particular meeting that criteria that share a common word between them. What is the word?


*The question ended up changing a bit later, but I obviously forgot to copy the new version. Honestly, the new version seemed more confusing than the original, but I didn't answer any of them! Haha.*

I broke this question down into sections:

1. closely related dependency did end up getting installed successfully - **H1** JAVA JDK
2. where did it land? - "install location"
3. Nearby on-and-off friends - **H2** Libraries / Includes?
4. particular file seems rather an ELFant - **H3** Executable, **H4** Big, **H5** Odd
5. search out offsets beginning with "404"
6. There are three in particular - **Evidence for** bigger file


#### Related dependency

* **E1** Location /usr/local/jdk1.8.0_151 exists with JDK bin.
* **E2** /home/hadoop/.bash_history shows how JDK was manually installed:

```bash
tar zxf jdk-8u151-linux-x64.tar.gz 
ls
sudo mv jdk1.8.0_151/ /usr/local/
ll /usr/local/jdk1.8.0_151/
export JAVA_HOME=/usr/local/jdk1.8.0_151
export PATH=PATH:$JAVA_HOME/bin
```

* **H1** Supported - /usr/local/jdk1.8.0_151 was installed manually. (Point 2 also answered)

#### Library

Nearby on-and-off friends make me think we are looking for the ```lib``` folder. Inside lib there is a *single ELF*. This potentially supports **H5**. However, the last offset in Hex is ```0x29507```. It's not large enough to find 3 offsets starting with 0x404.

**H6** The offsets are not in Hex. <-- That would suck, but the offsets might be in decimal or octets. I doubt that's true, but I should list it anyway.

There are no other ELFs in the lib folder. There is nothing suspicious in the include folder.

I will say **H2** is not supported (but I will be open if we find evidence).

#### Bin

The bin folder contains many executables (ELF). One file, unpack200, is the largest file in the directory. The problem is that the last offset is ```0x38839``, which means it's not big enough.

**H3, H4, and H5** are still outstanding. I have no evidence to support or deny the claims.

The biggest file is in the root JAVA directory, "src.zip." Based on the "ELF" comment, I would guess we are looking for an ELF, not that it is near an ELF.

### Conclusions

Unfortunately, that's all I had time for this week. I brute-forced some keywords for a few different ELFs, but no-go. Based on the fact that the 404 offset needs to be found three times, we are probably dealing with a relatively large file. If I had more time, I would look into the compressed files more. From the files I can see in the JDK folder, there is nothing super apparent that would be large enough to have three words at the particular offers.

Part 2: **BUST!!**