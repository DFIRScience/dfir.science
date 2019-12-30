---
layout: single
title: "Tsurugi Linux for Digital Forensics - Download and verify"
date: '2019-12-30T19:14:54+09:00'
author: "Joshua I. James"
tags:
  - infosec
  - dfir
  - linux
  - tsurugi
modified_time: ""
---
[Tsurugi Linux](https://tsurugi-linux.org/) is a DFIR Linux distribution by [*Backtrack and Deft Linux veterans*](https://tsurugi-linux.org/about_us.php). I loved DEFT, and was excited to see what the Tsurugi team had planned. This post is about downloading Tsurugi Linux, verifying the download and importing the vritual appliance into VirtualBox.

{% include video id="Bz_KcWV1OQQ" provider="youtube" %}

Today we are going to download and verify Tsurugi Linux - a Linux distribution for digital forensic investigations. Tsurugi requires a two-step verification process where a hash value is signed with the dev's key. We will download the Tsurugi Linux ISO / Virtual Machine, verify the SHA256 hash value and verify the signed hash using GPG. Once we have verified our download, then we import the VM into VirtualBox, and start-up our brand new Tsurugi Linux!

My base system is Linux Mint, but if you have [GPG4Win](https://www.gpg4win.org/) you should be able to follow along.

## Download

Tsurugi Linux [download](https://tsurugi-linux.org/downloads.php) page lists the public key of the developergit add. Download the public key listed there, and import it into your GPG keyring like so:

```bash
wget https://tsurugi-linux.org/tsurugi_linux_pub_key_BC006C0D.asc
gpg --import tsurugi_linux_pub_key_BC006C0D.asc

gpg: key BC006C0D: public key "Tsurugi Linux Core Develop <coredev@tsurugi-linux.org>" imported
gpg: Total number processed: 1
gpg:               imported: 1  (RSA: 1)
```

Next, download the hash file and the signature file. In this case, I will download the hash file for the Tsurugi Lab ISO.

```bash
wget https://tsurugi-linux.org/tsurugi_lab_2019.2.iso.sha256
wget https://tsurugi-linux.org/tsurugi_lab_2019.2.iso.sha256.sig
```

Now we can verify the hash file with the signature and developer key.

```bash
gpg --verify tsurugi_lab_2019.2.iso.sha256.sig

gpg: assuming signed data in `tsurugi_lab_2019.2.iso.sha256'
gpg: Signature made Thu 19 Dec 2019 07:24:11 AM KST using RSA key ID BC006C0D
gpg: Good signature from "Tsurugi Linux Core Develop <coredev@tsurugi-linux.org>"
gpg:                 aka "Tsurugi Linux info <info@tsurugi-linux.org>"
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 11C8 A884 AA43 342F 150D  56AC 4B60 8723 BC00 6C0D
```

From the third line of the output, we can see that the signature is good.

Next we just need to download and verify the ISO (about 4GB). Instead of doing a direct download,
I would recommed using the torrent. Once your torrent download is complete, please seed the distribution
so other investigators can get fast access to forensic software.

```bash
wget https://archive.org/download/tsurugi_lab_2019.2/tsurugi_lab_2019.2.iso
sha256sum -c tsurugi_lab_2019.2.iso.sha256

tsurugi_lab_2019.2.iso: OK
```

At this stage, we have downloaded and verified the ISO. Now you can burn the ISO to DVD and use it as an install disk
on your forensic workstation.

## Resources

See the links below for download managers and torrent clients. Please seed DFIR Linux Distros for the community!

<https://bit.ly/2Ij9Ojc> -- Subscribe for more videos and updates!

Support DFIR.Science on Patreon - <https://www.patreon.com/dfirscience>

Links:

* <https://tsurugi-linux.org/>
* uGet: <https://ugetdm.com/>
* Bittorrent client: <https://www.qbittorrent.org/>
* <https://www.virtualbox.org/>
