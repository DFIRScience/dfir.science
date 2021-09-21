---
layout: single
title: "Amazon AWS EC2 Forensic Memory Acquisition - LiME"
date: '2021-09-21T08:00:00-05:00'
author: "Joshua I. James"
tags:
  - digital forensics
  - incident response
  - infosec
  - tools
header:
  image: /assets/images/posts/headers/GenericCode.png
  caption: "Photo by [Markus Spiske](https://unsplash.com/@markusspiske?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/amazon-web-services?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)"
modified_time: ""
---

EC2 Forensics can use many of the same tools and techniques as computer forensics. Usually, just with the addition of networking concepts. In this video, we conduct EC2 Forensic memory acquisition using LiME on Amazon Linux 2. We create a lime formatted memory image of an EC2 Instance running Amazon Linux 2. However, this technique can be applied to most remote Linux forensic memory acquisitions.

We are conducting a live remove memory acquisition and demonstrate how to pair LiME and Netcat (NC) to transfer an image out of a firewalled target system.

{% include video id="3oto8Bl2vaE" provider="youtube" %}

When using this method try to get as much information about the target system beforehand as possible. Be ready with a similar system that way you can change kernels quickly and combine a compatible version of LiME.

With any live data forensics, avoid installing software on the target system, and minimize the number of commands entered in the target system.

Links:

* [LiME](https://github.com/504ensicsLabs/LiME)