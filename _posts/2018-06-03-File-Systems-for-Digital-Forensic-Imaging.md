---
layout: posts
title: 'Testing File Systems for Digital Forensic Imaging'
date: '2018-06-03T13:23:20+09:00'
author: Joshua
tags:
- infosec
- dfir
- disk imaging
- file system
- optimization
- zeltser
modified_time: '2018-06-03T13:23:20+09:00'
---

# Introduction - the problem
Recently I've been doing a lot of large disk forensic imaging. I usually use Linux-based
systems for forensic imaging. A normal case would be physical imaging of a source to an ext4 formatted destination.
I would normally get about 120MB/s imaging speed, depending on the source disk.

One day I was asked to save image files to an NTFS destination for compatibility with Windows.
Regardless of source, I kept getting 33MB/s imaging speeds on Linux (Ubuntu) to an NTFS destination.
Trying to figure out what was going on, we found the [NTFS-3G](https://wiki.archlinux.org/index.php/NTFS-3G)
driver is a major problem. The FUSE-based driver is both slow, and *appears* to use a lot of processing power.

The best description of this problem can be seen in Figure 1 below. In the top right graph, the
yellow line shows the NTFS-3G driver speeds; exactly what I was seeing.

<img src="/assets/images/posts/TuxeraStats.png" />
Figure 1: Disk read and writes using various drivers from [Tuxera](https://www.tuxera.com/products/tuxera-ntfs-embedded/)

Tuxera contributes to the NTFS-3G driver, and also sells their proprietary driver. I asked for a quote, and there
is no practical licensing options for a small forensics lab.

## Research questions
The speed and processor issues writing to NTFS made me think a lot more about optimization
of writes for all file systems. Specifically, disk imaging where a large, compressed images
needs written to a destination as fast as possible.

My research questions:
1. Is there a benefit to using a file system?
2. Is there a cost to using a file system?
3. What file systems are 'best' for each OS?

## The idea
At this stage, I suspect that - for disk imaging - raw writes to a destination with *no* traditional file system
would be much more efficient for disk imaging. If we write something like a partition table to the beginning of
our RAW destination, we can keep track of the disk images. After that, we can access the data directly on disk
at the speed of the hardware.

# Testing idea
Before trying to develop something, I need to do a lot more research. I've seen some
forensic file systems described before, but could never get them installed. If anyone knows
of prior work, please send it to me at [@DFIRScience](https://twitter.com/DFIRScience).

Next, I need to collect more objective measurements in our lab. An interesting blog that talks
 about file system latency measurements can be found here: [File System Latency](http://dtrace.org/blogs/brendan/2011/05/11/file-system-latency-part-1/).
The author is testing a MySQL server, but the testing method seems relevant.

There are two tools used in that blog. *iostat* is part of the *stsstat* package.
*dtrace* is part of the *systemtap-sdt-dev* package.

```
apt install sysstat systemtap-sdt-dev
```

> iostat is a computer system monitor tool used to collect and show operating system storage input and output statistics. It is often used to identify performance issues with storage devices, including local disks, or remote disks accessed over network file systems such as NFS. It can also be used to provide information about terminal input and output, and also includes some CPU information.
>
><cite><a href="https://en.wikipedia.org/wiki/Iostat">Wikipedia</a></cite>

> DTrace is a comprehensive dynamic tracing framework created by Sun Microsystems for troubleshooting kernel and application problems on production systems in real time.
>
><cite><a href="https://en.wikipedia.org/wiki/DTrace">Wikipedia</a></cite>

With this beginning information, I want to better understand the overhead of <acronym title="File System">FS</acronym> drivers.
I focused so much on file system investigation, I wasn't really thinking about write optimization during imaging. Time to begin!
