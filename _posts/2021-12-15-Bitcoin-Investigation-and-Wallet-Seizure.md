---
layout: single
title: "Bitcoin Investigation and Wallet Seizure"
permalink: /:year/:month/:title
date: '2021-12-15T09:49:28-06:00'
tags:
  - dfir
  - forensics
  - blockchain
  - cryptocurrency
header:
  image: /assets/images/posts/headers/bitcoin.jpg
  caption: "Photo by [Executium](https://unsplash.com/@executium?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/fast?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)"
modified_time: ""
---

{% include video id=d2kMmNyNo00 provider=youtube %}

Bitcoin investigation - and cryptocurrency investigations in general - benefit from access to a transparent ledger system - or blockchain - that investigators can directly monitor. There are many free tools for investigating transactions on the blockchain that are suitable for basic lookups of only a few addresses. We show the difference between a custodial wallet on an exchange (Coinbase) and a locally-installed wallet (Electrum).

Transactions from an exchange normally occur within an overall exchange wallet rather than an individual user wallet. Getting access to the user's account either directly or through the exchange company will often give access to the assets associated with the account.

Thank you to all of our Patrons for sponsoring DFIR Science.
Especially The Ranting Geek. Thank you so much!

A local wallet, however, is controlled only by the wallet owner. The wallet has an associated master key and seed phrase that are useful for investigators. Each wallet can contain many Bitcoin (or other currency) addresses. Each Bitcoin address has a corresponding private key. Access to the private key would allow others to take over that Bitcoin address. Access to the private master key or see would allow others to take over the entire wallet. Look for private keys or seed phrases to seize a cryptocurrency wallet.

This video covers several cryptocurrency topics and tries to show how each topic is related. We then discuss cryptocurrency investigation from a digital forensic perspective. Seizing cryptocurrency addresses and wallets is possible. Ideally, an investigator would have access to an unencrypted wallet, which would provide all necessary information to seize all Bitcoin. Usually, however, an investigator will find an encrypted wallet and should consider live data forensics techniques, especially RAM acquisitions, as well as standard search and interrogation techniques.