---
layout: single
title: "Detecting manual clock modifications"
date: '2020-09-28T22:05:37+09:00'
author: "Joshua I. James"
tags:
  - infosec
  - dfir
  - Q&A
modified_time: ""
---


I received a question from an aspiring forensic investigator taking the [Intro to Digital Forensics](https://dfir.science/dfs101/) course.

>Do forensic investigators have a way, either via the Registry or Event log, to look for a manual time change?

Great question. You should check the time set in BIOS, if possible, as a reference. Most modern OS sync their time online, so even if the BIOS is wrong, the time in the OS may be correct, or close to. Either way, always compare the suspect system times (BIOS and OS) to a trusted time source, like your own watch/phone.

In terms of these time changes, if the BIOS failed then the clock is usually years off. This will be easy to detect since you'll see many user activities before the OS install time. The OS will most likely sync to the correct time on boot anyway, and there will be no, or few, "weird times."

Manual manipulation can be harder to detect since a user may set a clock back only a few hours or weeks. Lucky for us, there are many sources of time information related to user activities in a system. Plus, only modifying the time does not remove the action. Often, we care more about "did an action happen" than we do about when the action happened.

Anyway, many data structures are added sequentially. Take a log, for example. If you find something like this:

<pre>
  10:00 computer started
  10:01 open Internet Explorer
  10:02 browse to a website
  08:01 browse to a website
  10:05 browse to a website
</pre>

It's pretty easy to see that the log is not internally consistent. This could be an indicator of an incorrect clock and would need further investigation.

A lot of valuable timestamp information is in the Windows Registry. The registry contains timestamps for key updates AND often has internal consistency similar to a log file. With Registry backups, you could compare computer time information between registry snapshots.

To make matters more complicated, attackers could selectively modify individual file timestamps. File timestamp modification is probably a more significant risk to investigators than clock manipulation. However, the manipulated file is also in the context of the system. Other timestamp information could likely be used to show the inconsistency of a specific file in question.

Consistency is not only related to timestamps, although timestamps are east to understand. Anything with an order has some consistency. For example, most recently used (MRU) lists have an order in which new entries are added to the list<sup>[1](#mru)</sup>. Using MRU consistency, you can know the order in which objects were used or accessed.

In summary, there is usually no direct place to see when and how a clock has been modified. However, there is so much recorded time information in a system that finding inconsistencies is usually possible. That's why I love timeline analysis. It lets you see exciting clusters of activities, even if they are not where you expect them to be.

 If you have a question about digital forensics, feel free to [contact us](https://dfir.science/contact), and we will respond asap.

<a name="mru"></a>[1] Zhu, et al. (2009) Temporal Analysis of Windows MRU Registry Keys. Advances in Digital Forensics V. Springer. [https://link.springer.com/chapter/10.1007/978-3-642-04155-6_6](https://link.springer.com/chapter/10.1007/978-3-642-04155-6_6)