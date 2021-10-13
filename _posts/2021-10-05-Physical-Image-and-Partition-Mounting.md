---
layout: single
title: "Physical Image and Partition Mounting in Tsurugi Linux"
date: '2021-10-05T09:00:00-05:00'
author: "Joshua I. James"
tags:
  - tools
header:
  image: /assets/images/posts/headers/harddrive.jpg
  caption: "Photo by [Benjamin Lehman](https://unsplash.com/@benjaminlehman?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/hard-drive?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)"
modified_time: ""
---

This is a basic DFIR skill, but extremely useful. Demonstrated on Tsurugi Linux.

Sometimes it is helpful to access data inside a forensic disk image without going through carving and processing. For example, when you want to use tools to search for or process data, the tools do not 'understand' forensic disk images. In this video, we use Tsurugi with ewfmount and the built-in 'mount' command to access a file system of a suspect disk image. The same commands will work on other versions of Linux as well.

Tsurugi Linux has pre-configured directories that make mounting disk images very easy. We will use an expert witness file (EWF) (E01) as an example. First, mount the physical disk image with ewfmount. Then use the Sleuth Kit mmls to find the partition table and get the offset to the target partition. Calculate the byte offset. Then use 'mount' to mount the target partition. From there, you should have access to the suspect's data as if their hard drive were directly connected to your system.

{% include video id="9uqS7-8At3g" provider="youtube" %}

Links:

* [Tsurugi Linux](https://tsurugi-linux.org/)