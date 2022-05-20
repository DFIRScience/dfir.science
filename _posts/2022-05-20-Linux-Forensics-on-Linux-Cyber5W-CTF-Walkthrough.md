---
layout: single
title: "Linux Forensics on Linux - Cyber5W CTF Walkthrough"
permalink: /:year/:month/:title
date: "2022-05-20T10:11:13-05:00"
tags:
  - dfir
  - ctf
  - walkthrough
  - infosec
header:
  og_image: "/assets/images/logos/dfir_card.png"
  image: "/assets/images/posts/headers/c5wlfctf.png"
  caption:
modified_time:
---

[Cyber5W](https://cyber5w.net/) released a [Mini Linux DFIR CTF](https://lfmus22.cyber5w.net/) based on the Magnet Summit 2022 live CTF. It is doable if you are new
to Linux investigations. A few questions are on the more intermediate end. If you don't get to investigate Linux very often,
this one is highly recommended! The CTF will be up until Jan 01, 2023, so you have plenty of time to work through it.

Today's post will be a walkthrough of the Mini Linux DFIR CTF. **There will be spoilers**. Read on at your peril. Also, I will use the Linux command line for all tasks.

# Verifying suspect data EWF E01 and forensic workstation setup

After [logging in](https://lfmus22.cyber5w.net/) to the platform, click "Download CTF Files," and you are presented with two E01 download links and their corresponding SHA1 hash values.

1. kubuntu-MUS22.E01  2a575d461d041e941bd4707afe9e8bb5e75548e2
2. mate-MUS22.E01     1167890df7d0acdae1efe97ae352035fa4ed1eeb

Once downloaded, verify both images. Note that E01 are [Expert Witness Format](https://www.loc.gov/preservation/digital/formats/fdd/fdd000406.shtml) images. They are likely using compression, and meta-data, such as the hash value, is stored inside the image footer.

What does this mean? If I hash the E01 file directly, I get the *wrong hash value*.

```bash
$ sha1sum mate-MUS22.E01 
f7c71d4d301bc80592798f2c5b4221263894fb49  mate-MUS22.E01
```

We have to use a tool that understands expert witness format. Basically, a tool will read the hash from the footer, decompress all the original data, and calculate the hash from the decompressed data. If you're on Windows, you can use something like [FTK Imager](https://www.exterro.com/ftk-imager). I use Linux as my forensic workstation, so I will use [*ewf-tools*](https://github.com/libyal/libewf/) utility called *ewfverify*. ewfverify will only calculate the MD5 sum by default, so we have to tell it to also calculate the SHA1 sum with the -d sha1 option.

```bash
$ sudo apt install ewf-tools
<snip>
$ ewfverify -d sha1 mate-MUS22.E01
Read: 80 GiB (85899345920 bytes) in 8 minute(s) and 2 second(s) with 169 MiB/s (178214410 bytes/second).

MD5 hash stored in file:    1a39206fd89b591f06d42c9850db8375
MD5 hash calculated over data:    1a39206fd89b591f06d42c9850db8375
SHA1 hash stored in file:   1167890df7d0acdae1efe97ae352035fa4ed1eeb
SHA1 hash calculated over data:   1167890df7d0acdae1efe97ae352035fa4ed1eeb

ewfverify: SUCCESS
```

Do the same thing for the next image:

```bash
$ ewfverify -d sha1 kubuntu-MUS22.E01
Verify completed at: May 20, 2022 10:42:23

Read: 119 GiB (128035676160 bytes) in 11 minute(s) and 42 second(s) with 173 MiB/s (182387003 bytes/second).

MD5 hash stored in file:    0cd689fe5771a89a12b0760c3cf11aa7
MD5 hash calculated over data:    0cd689fe5771a89a12b0760c3cf11aa7
SHA1 hash stored in file:   2a575d461d041e941bd4707afe9e8bb5e75548e2
SHA1 hash calculated over data:   2a575d461d041e941bd4707afe9e8bb5e75548e2

ewfverify: SUCCESS
```

## How to access data inside an EWF E01 forensic disk image

We could throw these images into some of our favorite forensic processing tools, such as [Autopsy](https://youtu.be/fEqx0MeCCHg). But I'm not going to do that. Instead, I'm going to mount the suspect image and investigate it like I am working with the live system. In Linux, this is extremely easy, and I don't have to wait for processing. Note, however, that if I needed to do a lot of data recovery, this might not be the best way to do it.

First, create two mount points on your local system. One for the "physical device" and one for the "logical device." Then we use *ewfmount* from ewf-tools to mount the EWF image to the "physical" mount point. Once mounted, ewfmount creates an ewf1 "device" containing our raw image data.

```bash
$ mkdir phy1
$ mkdir log1
$ sudo ewfmount kubuntu-MUS22.E01 ./phy1
$ sudo file ./phy1/ewf1
./phy1/ewf1: DOS/MBR boot sector
```

The "MBR boot sector" strongly hints that this is a physical disk image. Now we have the "physical" image mount, and we can access it directly. Let's check if there is partition information, and if so, let's mount the main partition to the "logical" mount point. We will use *mmls* from [The Sleuth Kit](http://sleuthkit.org/sleuthkit/) (TSK) to check partition information.

```bash
$ sudo apt install sleuthkit
$ sudo mmls ./phy1/ewf1
DOS Partition Table
Offset Sector: 0
Units are in 512-byte sectors

      Slot      Start        End          Length       Description
000:  Meta      0000000000   0000000000   0000000001   Primary Table (#0)
001:  -------   0000000000   0000002047   0000002048   Unallocated
002:  000:000   0000002048   0001050623   0001048576   Win95 FAT32 (0x0b)
003:  -------   0001050624   0001052671   0000002048   Unallocated
004:  Meta      0001052670   0250068991   0249016322   DOS Extended (0x05)
005:  Meta      0001052670   0001052670   0000000001   Extended Table (#1)
006:  001:000   0001052672   0250068991   0249016320   Linux (0x83)
007:  -------   0250068992   0250069679   0000000688   Unallocated
```

MMLS shows us partition information. Generally, I look for the biggest "length" first since that is often where user data is located. Here we have a *Linux* partition (006) that looks interesting. Let's mount that first and see what's in there.

To mount, we need the starting offset of the partition. The starting offset is reported in *sectors* by mmls, but we will need the byte offset. Luckily, mmls also tells us that "units are in 512-byte sectors", nice. So we do a little math:

```bash
$ echo 1052672 \* 512 | bc
538968064
```

The result is the byte offset for the 006 partition from the beginning of the physical disk. Now we can use standard Linux mount to mount the partition.

```
$ sudo mount -o ro,loop,offset=538968064 ./phy1/ewf1 ./log1
$ cd log1/
/log1$ ls
bin   cdrom  etc   lib    lib64   lost+found  mnt  proc  run   snap  swapfile  tmp  var
boot  dev    home  lib32  libx32  media       opt  root  sbin  srv   sys       usr
```

Now we have full access to the main partition. We can also tell from the directory structure that this is likely the system partition. But we're not done yet! You could use tools in your forensic workstation to analyze each file, and we may do that. However, I want to access the suspect system just like they would (from the command line). In Linux, we have an excellent tool called *chroot* which changes your system root to another directory. We can use *chroot* to change "into" the suspect system and run commands just like they would. When you look around, this way can be so much faster.

```bash
$ sudo chroot ./log1
root@Inara:/# 
```

The Linux system name stays the same, but the user changes from my local user to "root." Also, the "/" is the root directory of the suspect.

## Setup conclusions

I used this same process for both CTF images and answering everything was straightforward. This method gives you a "native view" of the system, which can be easier to navigate in some cases.

Note that this process looks complicated or might take a long time. It takes about one minute per image once you get used to the commands. You can mount raw images directly using this method without special tools.

Once you are finished with your analysis, you can unmount with *umount*. Unmount the logical device first.

```bash
$ sudo umount ./log1
$ sudo umount ./phy1
```

After unmounting, re-verify your suspect disk images.

# Mini Linux Forensics MUS22 - Mate Case

Instead of giving the full answer, I will give the Linux command that will get you very, very, very close to the right answer. If you used the chroot method described above, you can copy/paste. If not, you'll have to find the data source I'm talking about.

## Q1 What is the ID of the last boot?

```journalctl --list-boots```

[Journalctl](https://www.howtogeek.com/499623/how-to-use-journalctl-to-read-linux-system-logs/) can be used to display a lot of system log information. In our case, we are looking for the ID of the most recent boot. The most recent boot will be item 0 in the list, and the ID is in the second column. We can also see the boot date and time.

## Q2 How did the user install Google chrome on MATE?

```cat /var/log/apt/history.log | grep -i chrome```

In Debian-based systems like Mate/Kubuntu, applications are usually installed with the apt package manager. Now it's somewhat moving to snap or flatpak, but always check apt logs first. The apt history log can be found in */var/log/apt/history.log*. Here we use grep to filter the results for "chrome". If you get a hit, that means apt was used to install. Check the complete command to confirm.

## Q3 What date and time did the user install it?

```cat /var/log/apt/history.log | grep -i -B1 chrome```

Same as Q2 except we want the date and time of installation. The apt history also keeps date and time info, but grep will only return the matching line. Add context before the keyword match with -B1 (so show one line before the match). One line before the apt command entry is the date and time.

## Q4 The name of a repository from which more than one extra application was installed from?

```ls /etc/apt/sources.list.d/```

Kinda an oddly-worded question, but it is asking for custom apt repositories. We can check */etc/apt/sources.list* file for custom entires as well as */etc/apt/sources.list.d/*. Entries in sources.list.d are likely from adding a PPA, or from an external software installation. We can also check */var/log/apt/history.log* again to see what software was installed. You will need to enter the name of the custom repository.

## Q5 What is the name of the desktop session?

```cat /var/log/auth.log | grep -i session```

Desktop sessions are usually related to authentication. Check the system authentication log from /var/log/auth.log. We want to see only the session information. That will tell you the session name.

## Q6 What was the name of the suspicious domain the user visited from MATE?

```bash
cat /home/user1/.bash_history | more
cat /etc/hosts
```

This question requires two parts. First, check the user's .bash_history file for any suspicious domains. Nothing very suspicious, but we did find the user editing [/etc/hosts](https://www.makeuseof.com/tag/modify-manage-hosts-file-linux/) which is related to static DNS. Just to check, look at the contents of /etc/hosts and we find an manual entry that is very suspicious.

# Mini Linux Forensics MUS22 - Kubuntu Case

Both images were mounted the same way as described in the above sections.

## Q1 How did the user install Google chrome, date, time?

```cat /var/log/dpkg.log* | grep -i chrome```

Instead of using apt the user download a .deb package and installed the package "manually" with dpkg. Check the dpkg log, and you will find a chrome entry. You will not see an entry for chrome in apt history.

## Q2 How did the device go to sleep?

```cat /var/log/auth.log* | grep -i -B3 \'sleep\'```

System state such as boot, reboot, sleep are also associated with authentication. Check the authentication log for sleep. Add 3 lines before a match for context and you should see what causes a sleep event.

## Q3 How many privileged commands did the user run?

```cat /var/log/auth.log* | grep -i command | wc -l```

For privileged commands the user must authenticate. We can check the system authentication log, and search for "command". That will show commands the user tried to run with *sudo*. Once we filter the sudo commands, use *wc -l* to count the number of lines returned, and that is number of commands.

## Q4 What application was used to open the Top devices file?

```grep -ri "top devices" *```

Run this command in the */home/user/.config/* and */home/user/.local/share/* directories. This grep command looks for matches of "top devices" in any file contents. One specific application returns all related hits.

## Q5 What was the UUID of the main root volume?

```cat /var/log/dmesg* | grep -i uuid```

There are many places to find this answer, but I went with dmesg logs. When the system boots it looks for the main hard drive based on the UUID. As such, this UUID gets logged in several locations.

# Conclusions

This was a fun, quick CTF. Most of all I wanted to show how you can get easy, direct access to Linux systems under investigation. With mount and chroot you can get a "native view" inside the suspect system and use familiar tools to parse data. Really the only *forensic tools* we used were [ewf-tools](https://github.com/libyal/libewf/) and [The Sleuth Kit](http://sleuthkit.org/sleuthkit/).

I hope this approach to Linux Forensics was interesting. Hit me up on [Twitter](https://twitter.com/dfirscience) if you have any questions about the CTF, Linux or Digital Forensics!