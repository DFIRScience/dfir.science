---
layout: single
title: "iPhone forensics with Linux command line and bplister"
date: '2021-12-01T09:24:57-06:00'
tags:
  - infosec
  - dfir
  - iOS
  - linux
header:
  image: /assets/images/posts/headers/linuxCLI.jpg
  caption: "Photo by [Gabriel Heinzer](https://unsplash.com/@6heinz3r?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/fast?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)"
modified_time: ""
---

iPhone (iOS) forensics is somewhat complicated by difficult data structures in the device. However, it is possible to do a quick iPhone investigation with basic Linux command-line tools. We show how to use some basic Linux commands to search for files and file contents in an iPhone for a quick investigation.

If you are doing a forensic investigation of any Apple device, you will probably find binary plists (bplists). In that case, you will need a parser to help make sense of the data. Luckily, a command-line tool 'bplister' exists that can parse out bplists from an iPhone. Combine that with standard Linux tools and you have all you need to do a quick basic investigation of an iPhone dump. No need to be intimidated by iPhone forensics. Just treat it like a standard device investigation.

{% include video id="Fx_rKzMe8dQ" provider="youtube" %}

Links:
* bplister: (https://github.com/threeplanetssoftware/bplister)

Marsha's iPhone Image:
* [https://d17k3c8pvtyk2s.cloudfront.net/CTF21/CTF21_Marsha_iPhoneX_FFS_Premium_2021_07_29.zip.001]
* https://d17k3c8pvtyk2s.cloudfront.net/CTF21/CTF21_Marsha_iPhoneX_FFS_Premium_2021_07_29.zip.002
* https://d17k3c8pvtyk2s.cloudfront.net/CTF21/CTF21_Marsha_iPhoneX_FFS_Premium_2021_07_29.zip.003

Password: 02DB2ECE91DB67E8FA939FC3DC15D16B