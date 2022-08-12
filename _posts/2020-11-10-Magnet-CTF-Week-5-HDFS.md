---
layout: single
title: "Magnet CTF Week 5 - HDFS around the block"
date: '2020-11-10T13:00:00+09:00'

tags:
  - infosec
  - dfir
  - CTF
  - Magnet
modified_time: ""
---
Magnet Forensics is running a *weekly* forensic CTF. More information can be found on their [blog](https://www.magnetforensics.com/blog/magnet-weekly-ctf-challenge/). It is a fun way to practice, so let's get to it!

### CTF Posts

[Week 1](https://dfir.science/2020/10/Magnet-CTF-Week-1-Timestamps-of-doom.html) | [Week 2](https://dfir.science/2020/10/Magnet-CTF-Week-2-URLs-in-Pictures-in-Pictures.html) | [Week 3](https://dfir.science/2020/10/Magnet-CTF-Week-3-Failed-connections.html) | [Week 4](https://dfir.science/2020/11/Magnet-CTF-Week-4-GUIDSWAP-and-drop.html)

### Getting Started

Download the images from [Archive.org](https://archive.org/details/Case2-HDFS).

Week 5 question:

> What is the original filename for block 1073741825?

Way, way, way back in the day, I learned digital forensic **practice** with [Linux LEO](https://linuxleo.com/). So every time I see "block," I immediately think of [the Sleuth Kit](http://sleuthkit.org/).

### Starting the investigation

Taking a look at the question, I'm drawn to "original filename." Does this mean the file has been renamed/deleted/overwritten?

We are given a block ID, which - if the question is direct - is pretty easy to find the allocated file name.

This week we are also given three separate disk images.

**Hypothesis 1 (H1):** A file is allocated at block 1073741825 on one of the disk images.

**H2:** A file *was* allocated at block 1073741825 but was deleted or renamed.

### Understanding the disk image

Use ```mmls``` to find the partition layout.

```bash
$ mmls HDFS-Master.E01
DOS Partition Table
Offset Sector: 0
Units are in 512-byte sectors

      Slot      Start        End          Length       Description
000:  Meta      0000000000   0000000000   0000000001   Primary Table (#0)
001:  -------   0000000000   0000002047   0000002048   Unallocated
002:  000:000   0000002048   0163577855   0163575808   Linux (0x83)
003:  -------   0163577856   0163579903   0000002048   Unallocated
004:  Meta      0163579902   0167770111   0004190210   DOS Extended (0x05)
005:  Meta      0163579902   0163579902   0000000001   Extended Table (#1)
006:  001:000   0163579904   0167770111   0004190208   Linux Swap / Solaris x86 (0x82)
007:  -------   0167770112   0167772159   0000002048   Unallocated
```

Looks pretty standard for Linux. We can see our main partition starts at offset 2048, as we would expect. It looks like some extra space we might need to keep an eye on (Unallocated and DOS Extended). Checking the other two disks look the same.

We already have a problem, though. The end address for the disk is ```0167772159```, and we are looking for ```1073741825```. To confirm, we can try to read the block we are looking for:

```bash
$ icat -o 2048 HDFS-Master.E01 1073741825
Metadata address too large for image (5111809)
```

The other disk images have the same layout, so they won't help us either. This means that **H1** is **false** - no evidence to support. **H2** is technically false if we talk about the current disk layout. However, we will keep H2 in play and focus on a possible explanation.

We have two other disk images, and their naming leads me to believe that these may be in some type of cluster configuration. A quick search for HDFS (it was in the file name) reveals it is part of the [Hadoop Distributed File System](https://hadoop.apache.org/docs/r1.2.1/hdfs_design.html).

**H3:** The block is allocated in HDFS.

Just for fun, I list all file names (not contents) and search for "hdfs" and "1073741825."

I also checked bashrc to find HDFS_Home -> ```/usr/local/hadoop```.

```bash
$ fls -Fpro 2048 HDFS-Master.E01 | grep hdfs | more
# A lot of hits - hdfs is installed
# /usr/local/hadoop looks very interesting
$ fls -Fpro 2048 HDFS-Master.E01 | grep 1073741825
# Nothing
$ fls -Fpro 2048 HDFS-Slave1.E01 | grep 1073741825
r/r 2629793:  usr/local/hadoop/hadoop/dfs/name/data/current/BP-1479872265-192.168.2.100-1510165901692/current/finalized/subdir0/subdir0/blk_1073741825_1001.meta
r/r 2629792:  usr/local/hadoop/hadoop/dfs/name/data/current/BP-1479872265-192.168.2.100-1510165901692/current/finalized/subdir0/subdir0/blk_1073741825
r/r * 2629792(realloc): usr/local/hadoop/hadoop/dfs/name/data/current/BP-1479872265-192.168.2.100-1510165901692/current/rbw/blk_1073741825
r/r * 2629793(realloc): usr/local/hadoop/hadoop/dfs/name/data/current/BP-1479872265-192.168.2.100-1510165901692/current/rbw/blk_1073741825_1001.meta
r/r 2367349:  usr/local/hadoop/hadoop2_data/hdfs/datanode/current/BP-1479872265-192.168.2.100-1510165901692/current/finalized/subdir0/subdir0/blk_1073741825_1001.meta
r/r 2367348:  usr/local/hadoop/hadoop2_data/hdfs/datanode/current/BP-1479872265-192.168.2.100-1510165901692/current/finalized/subdir0/subdir0/blk_1073741825
```

Oh oh! So HDFS does have an allocated block 1073741825. It does not exist on Master. Reading up on HDFS, we find that the Master node is in charge of coordination and the other nodes are in charge of storage. There is support for **H3**.

Let's look at the contents of block 2629792:

```bash
$ icat -o 2048 HDFS-Slave1.E01 2629792
# deb cdrom:[Ubuntu-Server 16.04.1 LTS _Xenial Xerus_ - Release amd64 (20160719)]/ xenial main restricted

# deb cdrom:[Ubuntu-Server 16.04.1 LTS _Xenial Xerus_ - Release amd64 (20160719)]/ xenial main restricted
#<!SNIP>
```

That looks a lot like an apt sources list.

### Next stage

If the second node contains the block, the Master must hold the file location information.

**H4:** HDFS has a type of file allocation table that is stored on the Master.

Reading a [bit more](https://www.educba.com/hdfs-architecture/) about HDFS, we are interested in FsImage, edits, and possibly checkpoint files.

From before, we can find them in the master image at ```/usr/local/hadoop/hadoop2_data/hdfs/namenode/current```.

We have a few fsimage files that are numbered.

```bash
r/r * 3014665(realloc): opt/hadoop/hadoop/dfs/name/current/fsimage.ckpt_0000000000000000000
r/r 3014665:  opt/hadoop/hadoop/dfs/name/current/fsimage_0000000000000000000
r/r 3014666:  opt/hadoop/hadoop/dfs/name/current/fsimage_0000000000000000000.md5
r/r 1441824:  tmp/hadoop-hadoop/dfs/namesecondary/current/fsimage_0000000000000000024
r/r 1441825:  tmp/hadoop-hadoop/dfs/namesecondary/current/fsimage_0000000000000000024.md5
r/r 1441827:  tmp/hadoop-hadoop/dfs/namesecondary/current/fsimage_0000000000000000026
r/r 1441828:  tmp/hadoop-hadoop/dfs/namesecondary/current/fsimage_0000000000000000026.md5
r/r * 2367353:  usr/local/hadoop/hadoop2_data/hdfs/namenode/current/fsimage_0000000000000000016.md5
r/r * 2367351(realloc): usr/local/hadoop/hadoop2_data/hdfs/namenode/current/fsimage_0000000000000000016
r/r 2367360:  usr/local/hadoop/hadoop2_data/hdfs/namenode/current/fsimage_0000000000000000024
r/r 2367361:  usr/local/hadoop/hadoop2_data/hdfs/namenode/current/fsimage_0000000000000000024.md5
r/r * 2367352(realloc): usr/local/hadoop/hadoop2_data/hdfs/namenode/current/fsimage.ckpt_0000000000000000026
r/r 2367352:  usr/local/hadoop/hadoop2_data/hdfs/namenode/current/fsimage_0000000000000000026
r/r 2367365:  usr/local/hadoop/hadoop2_data/hdfs/namenode/current/fsimage_0000000000000000026.md5
```

#26 looks like the most recent, and we appear to have information as early as 24. I would guess these are like snapshots.

```bash
$ icat -o 2048 HDFS-Master.E01 2367352 | xxd
00000000: 4844 4653 494d 4731 1608 b8c5 8fd4 0110  HDFSIMG1........
00000010: e807 18ea 0720 0028 8280 8080 0430 1a06  ..... .(.....0..
00000020: 0884 8001 1004 2f08 0210 8180 011a 002a  ....../........*
00000030: 2508 d3f3 d1e7 f92b 10ff ffff ffff ffff  %......+........
00000040: ff7f 18ff ffff ffff ffff ffff 0121 ed01  .............!..
00000050: 0200 0001 0000 3408 0210 8280 011a 0474  ......4........t
00000060: 6578 742a 2608 bdca fef0 f92b 10ff ffff  ext*&......+....
00000070: ffff ffff ffff 0118 ffff ffff ffff ffff  ................
00000080: ff01 21ed 0102 0000 0100 0041 0801 1083  ..!........A....
00000090: 8001 1a09 4170 7453 6f75 7263 6522 2e08  ....AptSource"..
000000a0: 0210 989e d2e7 f92b 18dc 97d2 e7f9 2b20  .......+......+ 
000000b0: 8080 8040 29a4 0102 0000 0100 0032 0c08  ...@)........2..
000000c0: 8180 8080 0410 e907 18a4 1750 0041 0801  ...........P.A..
000000d0: 1084 8001 1a08 7365 7276 6963 6573 222f  ......services"/
000000e0: 0802 10b1 cafe f0f9 2b18 fbc4 fef0 f92b  ........+......+
#<SNIP>
```

We have a ```HDFSIMG1``` header, and it looks like some file information. This appears to be our cluster file info! Going to go ahead and say **H4** is supported (more research confirmed).

I exported fsimage #26, and used [hdfs fsimage dump](https://github.com/lomik/hdfs-fsimage-dump) to parse.

```bash
$ ~/Downloads/hdfs-fsimage-dump/hdfs-fsimage-dump -i ../fsimage_0000000000000000026
{"Group":"supergroup","ModificationTime":"2017-11-09 09:13:14","ModificationTimeMs":1510186394941,"Path":"/text","Permission":"drwxr-xr-x","User":"hadoop"}
{"AccessTime":"2017-11-09 03:46:33","AccessTimeMs":1510166793180,"BlocksCount":1,"FileSize":2980,"Group":"supergroup","ModificationTime":"2017-11-09 03:46:34","ModificationTimeMs":1510166794008,"Path":"/text/AptSource","Permission":"-rw-r--r--","PreferredBlockSize":134217728,"Replication":2,"User":"hadoop"}
{"AccessTime":"2017-11-09 09:13:14","AccessTimeMs":1510186394235,"BlocksCount":1,"FileSize":19605,"Group":"supergroup","ModificationTime":"2017-11-09 09:13:14","ModificationTimeMs":1510186394929,"Path":"/text/services","Permission":"-rw-r--r--","PreferredBlockSize":134217728,"Replication":2,"User":"hadoop"}
```

I thought it would give me the block IDs, but nope. Dumping the rest of the fsimage files shows pretty much the same info. Notice we have a file named "AptSource." The allocated data was from an apt sources file. That could be interesting. Before that...

Now we need to finish **H2**. In the same folder as fsimage, we have "edits." The earliest with data looks to be #3 - #10.

```bash
$ fls -Fpro 2048 HDFS-Master.E01 | grep edits_0000000000000000003
r/r 2367349:  usr/local/hadoop/hadoop2_data/hdfs/namenode/current/edits_0000000000000000003-0000000000000000010
```

Taking a look at the contents:

```bash
$ icat -o 2048 HDFS-Master.E01 2367349 | xxd
00000000: ffff ffc1 0000 0000 1800 0000 0c00 0000  ................
00000010: 0000 0000 039e 4d91 9b03 0000 0044 0000  ......M......D..
00000020: 0000 0000 0004 0000 0000 0000 4002 0005  ............@...
00000030: 2f74 6578 7400 0001 5f9c f479 d300 0001  /text..._..y....
00000040: 5f9c f479 d306 6861 646f 6f70 0a73 7570  _..y..hadoop.sup
00000050: 6572 6772 6f75 7001 ed00 0000 0000 71fe  ergroup.......q.
00000060: ed7d 0000 0000 b200 0000 0000 0000 0500  .}..............
00000070: 0000 0000 0040 0300 192f 7465 7874 2f41  .....@.../text/A
00000080: 7074 536f 7572 6365 2e5f 434f 5059 494e  ptSource._COPYIN
00000090: 475f 0002 0000 015f 9cf4 8bdc 0000 015f  G_....._......._
000000a0: 9cf4 8bdc 0000 0000 0800 0000 0000 0000  ................
000000b0: 0668 6164 6f6f 700a 7375 7065 7267 726f  .hadoop.supergro
000000c0: 7570 01a4 0000 0000 0000 2344 4653 436c  up........#DFSCl
000000d0: 6965 6e74 5f4e 4f4e 4d41 5052 4544 5543  ient_NONMAPREDUC
000000e0: 455f 3230 3839 3134 3337 3634 5f31 000d  E_2089143764_1..
000000f0: 3139 322e 3136 382e 322e 3130 3001 0000  192.168.2.100...
00000100: 102a 0da7 b879 ec4d f0ac 31da b7b4 0d33  .*...y.M..1....3
00000110: 4400 0000 03ff 2a5a b720 0000 0014 0000  D.....*Z. ......
00000120: 0000 0000 0006 0000 0000 4000 0001 2d9c  ..........@...-.
00000130: 4fc0 1f00 0000 1400 0000 0000 0000 0700  O...............
00000140: 0000 0000 0003 e9b4 3682 2d21 0000 003a  ........6.-!...:
00000150: 0000 0000 0000 0008 0019 2f74 6578 742f  ........../text/
00000160: 4170 7453 6f75 7263 652e 5f43 4f50 5949  AptSource._COPYI
00000170: 4e47 5f01 0000 0000 4000 0001 008e 03e9  NG_.....@.......
00000180: 0000 ffff fffe 59f0 c5b8 0900 0000 7900  ......Y.......y.
00000190: 0000 0000 0000 0900 0000 0000 0000 0000  ................
000001a0: 192f 7465 7874 2f41 7074 536f 7572 6365  ./text/AptSource
000001b0: 2e5f 434f 5059 494e 475f 0002 0000 015f  ._COPYING_....._
000001c0: 9cf4 8f18 0000 015f 9cf4 8bdc 0000 0000  ......._........
#<SNIP>
```

It looks like the first file copied into HDFS was ```/text/AptSource```. If AptSource was copied first and is still allocated (#26), then AptSource was likely never moved, renamed, or deleted. **H2** is false. Checking the other edit files supports the claim that H2 is false.

### Conclusions

We established that H1, H2 are false, and H3 and H4 are supported. In other words, we started with a wrong guess and course-corrected as we learned more through the investigation.

From this, we can say that the original file name is "AptSource." **BING!!**

### Lessons Learned

* My first hypothesis is almost always wrong. In this case, I guessed the simple (and most likely) answer first without having additional information. If I would have research HDFS first, I may have come up with a better first hypothesis.
* Command-line tools are still awesome. Through this whole process, I used six command-line tools. Most of which are part of the Sleuth Kit. I did the entire investigation from the command line *while the image was indexing in a comprehensive tool.* I'm sure indexed searching will be useful later, but you can get very far with some basic tools (and good hypotheses!)