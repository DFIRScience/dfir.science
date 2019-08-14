---
layout: posts
title: "[How To] Volatility Memory Analysis Building Linux Kernel Profiles"
date: '2017-06-12T11:14:50+09:00'
author: Joshua
tags:
- Volatility
- Linux
- How To
- Memory analysis
- infosec
- dfir
- LiME
modified_time: '2017-06-12T11:14:50+09:00'
---

Memory foreniscs in Linux is not very easy. The reason is because the Linux kernel changes data structures and debug symbols often. Users can also easily modify and compile their own custom kernels. If we want to analize Linux memory using [Volatility](http://www.volatilityfoundation.org/), we have to find or create linux profiles for the version of Linux that we are trying to analize. Linux profile creation for Volatility is not that difficult. The [documentation](https://github.com/volatilityfoundation/volatility/wiki/Linux#getting-symbols) claims that Volatility will support profile sharing in the future, which should make Linux support much easier.

For now, we still have to make our own profiles. Please see the video below for details. We used [LiME](https://github.com/504ensicslabs/lime) for Linux memory acquisition.

{% include video id="qoplmHxmOp4" provider="youtube" %}
