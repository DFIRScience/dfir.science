---
layout: single
title: "Android logical acquisition with android_triage"
date: '2021-10-26T16:18:12-05:00'
tags:
  - infosec
  - dfir
modified_time: ""
---

In this video, we look at the android_triage utility that helps with fast android logical acquisitions. It uses the Android Debug Bridge (adb) to connect to a target android device and extract system information, log files, initiate backups, and do a full file system extraction. The result is a comprehensive dump of Android data without needing to memorize many adb commands.

android_triage is also set up to respect the Order of Volatility in the phone. Just use the features in order, and you will run from least invasive to most invasive. android_triage is pre-installed in Tsurugi Linux, which is the operating system we used for this example.

{% include video id="jRRH2YWSnhE" provider="youtube" %}