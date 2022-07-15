---
layout: single
title: "Mounting Linux Logical Volumes in Forensic Disk Images"
permalink: /:year/:month/:title
date: "2022-06-7T08:14:47-05:00"
tags:
  - infosec
  - dfir
  - linux
header:
  og_image: "/assets/images/logos/dfir_card.png"
  image: "/assets/images/posts/headers/genericTexture.webp"
  caption: "Photo by [Jr Korpa](https://unsplash.com/@jrkorpa?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/linux?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)"
modified_time:
---

Linux supports Logical Volume Management, which assists in managing partition features such as resizing and encryption. However, many forensic tools cannot directly access data on an LVM partition.

First, your forensic workstation must understand the volume group information, then access the logical volume. Once we can see the logical volume, we can mount it as normal. Today we look at mounting a logical volume from a Linux forensic disk image.

{% include video id="bRfq4OTHV5Q" provider="youtube" %}

We use Tsurugi Linux to work with the LVM and mount the logical volumes, though most versions of Linux should work just fine. If your forensic workstation has logical volumes and the volume group name is the same in the suspect disk, you could have some conflicts.

## Links

* [Guide to LVM in Linux](https://linuxhandbook.com/lvm-guide/)
* [Tsurugi Linux](https://tsurugi-linux.org/)
* [The Linux Programming Interface: A Linux and UNIX System Programming Handbook](https://amzn.to/3MbzE9v)