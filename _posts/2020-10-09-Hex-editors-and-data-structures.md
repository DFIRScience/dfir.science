---
layout: single
title: "Hex editors and data structures"
date: '2020-10-09T21:07:27+09:00'

tags:
  - infosec
  - dfir
  - Q&A
  - hex
modified_time: ""
---

A student sent a question about hex editors. Hex editors are often used in forensics to view and analyze data. Viewing data in hexadecimal (hex) instead of raw is much easier.

There are many hex-editors. Some have features that are specifically useful for forensic investigators, but most show the data.

If you are just starting in forensics, don't worry about the hex editor software, and focus more on understanding the contents (data) that it shows. This student was asking about HxD, but we can forget the hex editor for now.

Let's talk about the data structure of a JPEG. To make things a bit more confusing, they were asked to analyze EXIF meta-data (another structure) inside the JPEG header. It's like a box in a box.

Let's take a look at a random JPEG picture. I am using ```xxd``` a command-line hex editor in Linux to look at it (the editor doesn't matter).

```bash
~/$ xxd IMG_20200911_101905_667~2.jpg | head
00000000: ffd8 ffe1 0084 4578 6966 0000 4d4d 002a  ......Exif..MM.*
00000010: 0000 0008 0005 0100 0004 0000 0001 0000  ................
00000020: 0280 0101 0004 0000 0001 0000 030a 8769  ...............i
00000030: 0004 0000 0001 0000 005e 0112 0003 0000  .........^......
00000040: 0001 0001 0000 0132 0002 0000 0014 0000  .......2........
00000050: 004a 0000 0000 3230 3230 3a30 393a 3131  .J....2020:09:11
00000060: 2031 303a 3230 3a33 3700 0002 a406 0003   10:20:37.......
00000070: 0000 0001 0000 0000 9208 0004 0000 0001  ................
00000080: 0000 0000 0000 0000 ffe0 0010 4a46 4946  ............JFIF
00000090: 0001 0100 0001 0001 0000 ffdb 0043 0003  .............C..
```

The first 2-4 bytes are how we usually identify the file signature. In this case, you see ```ffd8``` at offset ```00000000```. Check [Gary Kessler's site](https://www.garykessler.net/library/file_sigs.html) for signature structures, and search for "ff d8". What type of file are you looking at?

Then look for "ff d8 ff e1" - the second part of the file signature. (spoiler) It's a JPEG image that supports EXIF (embedded file meta-data).

The next task is to find the timestamp information. To do that, we need to understand the EXIF structure. To do that, we have to look at the EXIF technical specification - if we can't find the spec, we have to reverse-engineer it. Luckily, the EXIF spec is [easy to find](http://www.cipa.jp/std/documents/e/DC-008-2012_E.pdf) (but not so easy to read).

Page 19 of the spec, you can see "TIFF header" - it is 2 bytes. It is either 4949 (little-endian) or 4D4D (big-endian). This tells us how to read the data. In my example, you can see at offset 0x0C (first line) it is ```4d4d```, so we know our data is in big-endian.

Look at Table 4 on page 28 (see page 39 for details) of the EXIF PDF. In D. Other tags, you will see "File change date and time" - hex value starts with ```0132```, and the data is in ASCII (good for us - easier to read).

In my data, you can see ```0132``` at 0x46. Next is ```0002```, which means ASCII (as expected). Then 4 bytes for timestamp length, then 4 for offset. 14 bytes from ```0132``` we get to ```3230```, which is the beginning of the timestamp in ASCII. Copy 20 bytes starting at offset 0x56 and you get: ```3230 3230 3a30 393a 3131 2031 303a 3230 3a33 3700```. You don't need to convert it since we have an ASCII view on the right: ```2020:09:11 10:20:37```

The hardest part is to find a good document that describes the data structure. The second "gotcha" is to know what offset they are asking about. Is it the offset from the beginning of the EXIF data, or the offset from the beginning of the file? Offsets are relative, so make sure you know your reference point! )(Especially in disk forensics.)

Hex editors show the data. Instead of focusing on the tool, the difficulty is usually in understanding the underlying data structures for the data you are looking at.