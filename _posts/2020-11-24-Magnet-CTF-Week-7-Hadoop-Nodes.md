---
layout: single
title: "Magnet CTF Week 7 - Hadoop Node Networking"
date: '2020-11-24T01:00:00+09:00'
author: "Joshua I. James"
tags:
  - infosec
  - dfir
  - CTF
  - Magnet
modified_time: ""
---
Magnet Forensics is running a *weekly* forensic CTF. More information can be found on their [blog](https://www.magnetforensics.com/blog/magnet-weekly-ctf-challenge/). It is a fun way to practice, so let's get to it!

### CTF Posts

[Week 1](https://dfir.science/2020/10/Magnet-CTF-Week-1-Timestamps-of-doom.html) | [Week 2](https://dfir.science/2020/10/Magnet-CTF-Week-2-URLs-in-Pictures-in-Pictures.html) | [Week 3](https://dfir.science/2020/10/Magnet-CTF-Week-3-Failed-connections.html) | [Week 4](https://dfir.science/2020/11/Magnet-CTF-Week-4-GUIDSWAP-and-drop.html) | [Week 5](https://dfir.science/2020/11/Magnet-CTF-Week-5-HDFS.html) | [Week 6](https://dfir.science/2020/11/Magnet-CTF-Week-6-Riddle-ELF.html)

### Getting Started

Download the images from [Archive.org](https://archive.org/details/Case2-HDFS).

Week 7 question is in three parts. Answering the first question releases the other questions.

> Part One: What is the IP address of the HDFS primary node?

As for disk images, we have one primary node and two secondary hadoop (HDFS) nodes. Often with clusters there is a primary node(s) that control how the cluster functions, and secondary processing/storage nodes that do some task. Task managment and distribution is often done by the primary node. **Hypothesis 1 (H1)** *the secondary node will contain a configuration file with the IP address of the primary node.*

Just like prior weeks, I like to check out *.bash_history* of a secondary node to give a hint as to what config files the user may have modified. In */home/hadoop/.bash_history* we can see some interesting commands:

```bash
<!--snip-->
vi /etc/hosts
sudo vi /etc/hosts
<!--snip-->
ping master
ping slave1
ping slave2
<!--snip-->
```

Here the suspect is attempting to access the /etc/hosts file. Later the user can ping hostnames directly. These host names could be from DNS, but it is likely that the hosts were set manually in the /etc/hosts file. **H2** hostnames for the cluster are set in the hosts file.

Checking /etc/hosts we see:

```bash
127.0.0.1	localhost
#127.0.1.1	hadoop-master

192.168.2.100 master.champforensics.com		master
192.168.2.101 slave1.champforensics.com		slave1
192.168.2.102 slave2.champforensics.com		slave2

# The following lines are desirable for IPv6 capable hosts
#::1     localhost ip6-localhost ip6-loopback
#ff02::1 ip6-allnodes
#ff02::2 ip6-allrouters
```

**H2** is supported, and **H1** is supported if we consider the hosts file to be a config for the cluster. Trying the master IP address of 192.168.2.100 and **BING!**. Success.

> Part Two: Is the IP address on HDFS-Primary dynamically or statically assigned?

Almost always nodes - especially control nodes - have IP addresses that are statically assigned. This means the IP is set on the device and does not change over time. DHCP, on the other hand, assigns IP addresses from a pool, and your system may get a different IP address sometimes. DHCP also allows for *reservations*. Basically the DHCP server will automatically assign a reserved address to a specific computer. In that case the computer's IP address would be "dynamic" but it would always be assigned the same address as if it were static.

We have to start somewhere, so I will guess that **H3** the IP address of the primary node is set statically. Let's check.

The primary node is using Linux, so we should check the /etc/network/interfaces file. This file has information about each network interface on the system.

```bash
# The primary network interface
auto ens33
iface ens33 inet static
	address 192.168.2.100
	netmask 255.255.255.0
	#gateway 192.168.2.1
	dns-nameservers 192.168.2.1 8.8.8.8
	network 192.168.2.0
	broadcast 192.168.2.255

auto ens36
iface ens36 inet dhcp
```

Here we have iface ens33 inet **static** followed by the network configuration. The 'address' field is the same as what we observed in the secondary node hosts configuration. This evidence supports **H3**.

Just as an aside, the interface ens36 is set for "dhcp". That is what we would expect if the address is dynamically assigned.

Answering part two with "static" and **BING!** Success.

> Part Three: What is the interface name for the primary HDFS node?

Lucky for us, part three has already been answered. The (primary) interface name for the primary node is "ens33", as observed in /etc/network/interfaces. Trying "ens33" and **BING!** Success.

## Lessons learned

This week all questions could have been answered by looking at ```/etc/network/interfaces``` on the primary node. I made it a bit more complicated because I wanted to see what information a secondary node could give me about the primary node. In this case, the secondary node hosts file was modified. However, I bet if we dig deeper the secondary node will have other pointers or config information back to the primary node that we could dig into.

It looks like question one and two could be answered or inferred from secondary node analysis. The primary node interface name, however, can *probably* only be found locally on the primary node. I don't know any "external" way to get a local interface name.