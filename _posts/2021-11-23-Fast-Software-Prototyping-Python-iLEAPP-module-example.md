---
layout: single
title: "Fast Software Prototyping in Python - iLEAPP module example"
date: '2021-11-23T08:10:06-06:00'
tags:
  - infosec
  - dfir
  - dev
header:
  image: /assets/images/posts/headers/pythonCode.jpg
  caption: "Photo by [Shahadat Rahman](https://unsplash.com/@hishahadat?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/fast?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)"
modified_time: ""
---

When adding code to a large project, like the iPhone forensic triage software iLEAPP, re-running the software over and over again to test your module can become tedious. Instead, prototype your parser in a smaller test file first. This video shows how to start prototyping a module for iLEAPP (or ALEAPP/WLEAPP), but once you have your idea and the libraries you need, develop it in a simple Python script outside of the framework.

Getting the parser working outside of the framework will save so much time by making the script as simple as possible. It will speed up run times and allow you to focus troubleshooting on a much smaller block of code.

The end result is both a stand-alone script that can parse some artifact (do some action), as well as an integrated module in iLEAPP (or whatever framework you are writing for).

{% include video id="8xBNppN0_58" provider="youtube" %}