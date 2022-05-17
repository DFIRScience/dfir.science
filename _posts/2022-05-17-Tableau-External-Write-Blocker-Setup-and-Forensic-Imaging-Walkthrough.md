---
layout: single
title: "Tableau External Write Blocker Setup and Forensic Imaging Walkthrough"
permalink: /:year/:month/:title
date: "2022-05-17T17:24:00-05:00"
tags:
  - infosec
  - dfir
  - hardware
header:
  og_image: "/assets/images/logos/dfir_card.png"
  image: "/assets/images/posts/headers/dfirscicover.png"
  caption:
modified_time:
---

Forensic write blockers prevent the forensic workstation from modifying the source disk. Physical write blockers physically prevent write commands from being sent to the disk, while software write blockers attempt to block writes at the kernel (OS) level. Today we look at three external physical write blockers and how a forensic investigator can use them.

Note that physical and software write blockers can fail. Test your write blocking solutions for regular and odd use cases, and document your results.
 
{% include video id="Kmm8iaa76rQ" provider="youtube" %}

The UltraBlock write blockers were generously loaned by [Digital Intelligence, Inc](https://bit.ly/DFIRSciDI).

### Links

* [Tableau UltraBlock External Write Blocker](https://bit.ly/DFIRSciUltraBlock)
* [Digital Intelligence, Inc.](https://bit.ly/DFIRSciDI)

### Related book

* [Practical Forensic Imaging](https://amzn.to/3l2tT2N)