---
layout: single
title: "Fast password cracking - Hashcat wordlists from RAM"
permalink: /:year/:month/:title
date: "2022-06-15T08:53:04-05:00"
tags:
  - infosec
  - dfir
  - hashcat
  - password cracking
header:
  og_image: "/assets/images/logos/dfir_card.png"
  image: "/assets/images/posts/headers/hashcat.webp"
  caption:
modified_time:
---

Password cracking often takes a long time. Brute force is normally your last option. But before that, a wordlist usually helps guess the password faster.

Popular wordlists like Rockyou are good for general cases, but making password lists specific to the user can produce faster results. One of the best data sources to produce a customized wordlist is a target's RAM.

We show how to use strings to extract password candidates from a RAM dump and use the resulting wordlist with Hashcat, a high-powered password cracking software.
 
{% include video id="lOTDevvqOq0" provider="youtube" %}

## Links

Links:
* [Hashcat Official](https://hashcat.net/hashcat/)
* [Hash Crack: Password Cracking Manual v3](https://amzn.to/3Hmpe63)