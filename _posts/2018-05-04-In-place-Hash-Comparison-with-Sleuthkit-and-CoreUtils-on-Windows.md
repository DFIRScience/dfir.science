---
layout: single
title: "In-place Hash Comparison with Sleuthkit and CoreUtils on Windows"
date: '2018-05-04T19:52:36+09:00'
author: Joshua
tags:
- infosec
- dfir
- Windows
- Sleuthkit
modified_time: '2018-05-04T19:52:36+09:00'
---

<style>.embed-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style><div class='embed-container'><iframe src='https://www.youtube.com/embed/NskT4P5ejH0' frameborder='0' allowfullscreen></iframe></div>

In this video we talk about how to do in-place file hash comparison from a disk image. We use the Sleuthkit and CoreUtils on Windows to extract file data, create an MD5 hash of the file data and use hfind to search a hash database.

Specifically, we analyze an Expert Witness File (E01). First we use mmls to extract partition information from the physical disk image. From that we can extract the partition offset. With the partition offset, we can use FLS to list the files in the partition. We show how to use icat and fcat to extract file data using the file inode or the file name. We feed the icat output into md5sum (coreUtils) and cut everything except the md5 hash value. Finally, we pipe the hash value into hfind (sleuthkit) to search whether the hash value is in the known database.

* Install Sleithkit on Windows: [https://youtu.be/1fIhQR5Rvdk](https://youtu.be/1fIhQR5Rvdk)
* Install CoreUtils on Windows: [https://youtu.be/m6Si0-Ac5Kc](https://youtu.be/m6Si0-Ac5Kc)
