---
layout: single
title: "How to enable SSH on a headless Rasberry Pi - Raspbian"
date: '2018-05-25T09:10:18+09:00'
author: Joshua
tags:
- infosec
- dfir
modified_time: '2018-05-25T09:10:18+09:00'
---

[Raspberry Pis](https://www.raspberrypi.org/) are great for all sorts of information security related projects. They come with HDMI and USB ports, so it is easy to connect monitors and keyboards. Sometimes, however, you just need a shell.

Raspbian used to have SSH enabled by default, with a default username and password. Not a great idea, since many people put these things on public IPs without any hardening.

For some perspective, I normally see the default Raspbian user name and password come in to my SSH honeypot within a few hours. Default on + login is not great here. So ssh is - wisely - not on by default.

Unfortunately, I only use SSH for Pi configuration, so I need it on. We need a way to enable SSH on Raspbian without the need for an extra monitor and keyboard. Raspbian has us covered.

## Write a Raspbian image to disk
To set up a Raspberry Pi, we need to [download](https://www.raspberrypi.org/downloads/) on operating system image. This image needs to be copied to a MicroSD card that will act as the system disk for your Pi.

<style>.embed-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style><div class='embed-container'><iframe src='https://www.youtube.com/embed/N17rPCj9ye8' frameborder='0' allowfullscreen></iframe></div>

## Open the Boot Partition
After copying the disk image to your system disk, open the "boot" partition. In the boot partition create an *empty file* with a file name "ssh".

In Linux, the commands are similar to this:
```
cd /media/user/boot/
touch ssh
```

*cd* is used to change into the boot directory. *touch* is used to create an empty file.

## Boot the Pi
Now you can boot your Pi and put it on the network (using a wired connection first). I usually scan the network with *nmap*.

```
nmap -sP x.x.x.x/24
```

You should eventually get something like this:
```
Nmap scan report for raspberrypi (x.x.x.x)
Host is up (0.0034s latency).
```

Now we can try to ssh into the listed IP. Use the username pi. We can use the username directly by typing - ssh pi@IP. The default password is *raspberry*.
```
~ $ ssh pi@x.x.x.x
The authenticity of host 'x.x.x.x (x.x.x.x)' can't be established.
ECDSA key fingerprint is SHA256:goOmZqIjyi+kJrbgKQ4oUF2PPJMxe6KjjnnEfnZ+wTc.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'x.x.x.x' (ECDSA) to the list of known hosts.
pi@x.x.x.x's password:
Linux raspberrypi 4.14.34-v7+ #1110 SMP Mon Apr 16 15:18:51 BST 2018 armv7l
pi@raspberrypi:~ $
```

## Update settings
Now that we are in the Pi, we need to change a few settings. First run raspi-config.
```
sudo raspi-config
```

Run *Change User Password* - do this first. Next go to *Advanced Options*, and select *Expand Filesystem*.

You can now set the Network Options if you want to join the Pi to a wifi network.

Finally, select *Update* from the menu. Once that is done select *Finish*, and restart.

You should create a new user, and disable the Pi user if you are using the Pi for longer projects.
