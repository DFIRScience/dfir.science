---
layout: single
title: "Bitcoin forensics - visualizing blockchain transactions with Maltego"
permalink: /:year/:month/:title
date: '2021-12-20T09:37:07-06:00'
tags:
  - dfir
  - investigation
  - cryptocurrency
  - bitcoin
header:
  image: /assets/images/posts/headers/bitcoin.jpg
  caption: "Photo by [Executium](https://unsplash.com/@executium?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/fast?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)"
modified_time: ""
---

Cryptocurrency investigations - like Bitcoin forensics - usually involve blockchain transaction analysis. You can use blockchain.com Explorer to look up Bitcoin, Etherium, and other blockchain transactions or addresses. However, the site is not very useful when attempting to analyze many transactions. Instead, visualizing the blockchain is much more helpful.

Blockchain analysis usually ends by finding a cryptocurrency exchange the suspect uses or when the suspect purchases services using illicit cryptocurrency. Active monitoring may be necessary to watch addresses of interest over time. Additionally, intelligence gathering is helpful when associating cryptocurrency addresses with service providers.

We use Maltego Community Edition with the blockchain.com transform to analyze WannaCry Ransomware Bitcoin transactions on the Bitcoin blockchain. Maltego will create a graph where nodes are Bitcoin addresses, and edges are the direction of transactions. Maltego can automatically generate node graphs based on either address relationships or blockchain transactions.

Getting started with Bitcoin forensics Maltego and the blockchain transform is an easy and free way to begin. Maltego can also include intelligence from many other sources, not just the Bitcoin blockchain. You can use investigation intelligence to enrich your graphs and find suspects' true identities behind the addresses.

{% include video id="_kTRx-_heCg" provider="youtube" %}
