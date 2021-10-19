---
layout: single
title: "Magnet CTF Week 1 - Timestamps of doom"
date: '2020-10-13T00:00:00+09:00'

tags:
  - infosec
  - dfir
  - ctf
  - timestamps
  - android
modified_time: "2020-10-13T21:44:00+09:00"
---

Magnet Forensics is running a *weekly* forensic CTF. More information can be found on their [blog](https://www.magnetforensics.com/blog/magnet-weekly-ctf-challenge/). It is a fun way to practice, so let's get to it!

### CTF Posts

[Week 1](https://dfir.science/2020/10/Magnet-CTF-Week-1-Timestamps-of-doom.html) | [Week 2](https://dfir.science/2020/10/Magnet-CTF-Week-2-URLs-in-Pictures-in-Pictures.html) | [Week 3](https://dfir.science/2020/10/Magnet-CTF-Week-3-Failed-connections.html)

### Getting Started

Download the Android data from [here](https://drive.google.com/file/d/1tVTppe4-3Hykug7NrOJrBJT4OXuNOiDO/view?usp=sharing). Note that the data was released October 5th, 2020 @ 11AM ET.

Calculate the hash of the suspect data:
```bash
sha1sum MUS_Android.tar 
10cc6d43edae77e7a85b77b46a294fc8a05e731d  MUS_Android.tar
```

Week 1 question:

> What time was the file that maps names to IP's recently accessed?
> (Please answer in this format in UTC: mm/dd/yyyy HH:MM:SS)

So far, we need to note a few things. First, the answer is a date-time stamp in UTC. The timestamp must be before Oct. 5th, 2020 @ 11AM.

A file that maps names to IP addresses is normally the **hosts** file. In Android, the hosts file is normally found in ```/system/etc/hosts```. The data is provided as a tar archive. We can search the archive without extracting it. Let's see if the hosts file is found:

```bash
tar -tv --full-time -f MUS_Android.tar --wildcards *hosts
-rw-rw-r-- 1023/1023        85 2020-03-05 14:50:18 data/media/0/Download/hosts
drwxr-xr-x 0/0               0 2020-03-05 14:47:56 data/adb/modules/hosts/
drwxr-xr-x 0/0               0 2020-03-05 14:46:41 data/adb/modules/hosts/system/
drwxr-xr-x 0/0               0 2020-03-05 14:46:41 data/adb/modules/hosts/system/etc/
-rw-r--r-- 0/0              85 2020-03-05 14:50:18 data/adb/modules/hosts/system/etc/hosts
-rw-r--r-- 0/0             155 2020-03-05 14:46:41 data/adb/modules/hosts/module.prop
-rw-r--r-- 0/0               0 2020-03-05 14:46:41 data/adb/modules/hosts/auto_mount
```

You can see two files - one in the Download directory and one in the expected system/etc directory. Weird that a hosts file would be in Download. It could be an indicator of tampering.

The times listed are the created times *in my local time zone*. UTC would be -8. We are looking for a recent access time.

In this case, the files in the archive do not appear to contain access time information. So the question **recently accessed** likely means **give a most recent access time that you can support**. In other words, we will need to use the context of the data to tell us when the hosts file was last accessed, not direct observation of the file's access timestamp. For something like this, it might be useful to use a timeline view of file timestamps.

We know that the hosts file has a modify time on 2020-03-05 14:50:18-8, so we can focus on that date for timeline analysis. We know what the recent access time should be between 2020-03-05 and 2020-10-05. Time modified time in UTC is 2020-03-05 05:50:18.

Looking at files with similar timestamps we can see the phone had [Magisk](https://magisk.me/) installed. That means it was likely rooted. It is also using [SolidExplorer](https://neatbytes.com/solidexplorer/) file manager.

Near the hosts file timestamp, we see a SolidExplorer database update. If we look into the SolidExplorer database, we see a recent_files table with three entries, all for "hosts" files. Each has a timestamp (which looks a lot like an access timestamp). So we break out our trusty [DCode](https://www.digital-detective.net/decode/) tool.

Decode shows /system/etc/hosts accessed at 2020-03-05 05:49:28. It shows Download/hosts accessed at 2020-03-05 05:53:50 (which is the same as the update time for SolidExplorer DB).

Note that we have one file with a path of /etc/hosts. However, that doesn't appear to be the real hosts file. We will need to check for /etc/hosts to see what that entry is all about. A quick keyword search for /etc/hosts shows ```.bash_history_root``` command ```vi /etc/hosts```. vi is a text editor, so it looks like the file was modified at 05:12:31. Our SolidExplorer database has an access timestamp of 05:10:16. Based on these times, it looks like SoldExplorer created /etc/hosts, and it was modified with vi on command line.

We also have ```.bash_history``` with entries for editing ```/etc/hosts```. The last modified time is 2020-03-05 22:53:45. After /etc/hosts was modified, the suspect installed cowsay. We can try to reduce the time-range by looking for these install times. Maybe in an apt log? From the apt history.log file, cowsay was installed around 2020-03-05 08:21:13. Unsure if the timestamp in the log is UTC or local -> looks like local, which means 13:21:13UTC. The phone must have been in UTC-5.

Remember that modified times are normally copied over when a file is copied. From this, it looks like the /system/etc/hosts file was accessed with SoldExplorer. Solid explorer [can edit configuration files](https://neatbytes.com/solidexplorer/index.php/2015/06/12/root-access-in-solid-explorer/). Then the file was saved at 05:50:18. After that, SoldExplorer was used to make a copy of hosts into the Download folder at 05:53:50. This would explain the same edit time, but different access times.

Magisk and Termux is installed, so the user has root-level access with command line utilities.

SolidExplorer DB shows three timestamps. That with .bash_history gives us a good idea of how the files were created.

1. Create /etc/hosts with SolidExplorer
2. Modify with VI
3. Move /etc/hosts to /system/etc/hosts with SolidExplorer
4. Modify with SolidExplorer editor
5. Copy /system/etc/hosts to /sdcard/Download/hosts
6. Open /sdcard/Download/hosts with SolidExplorer (not modify)


### Timeline

* Install root-repo with apt 2020-03-05 04:33:50 <-- (apt history.log)
* Apt full-upgrade at 2020-03-05 05:07:04  <-- (apt history.log)
* /etc/hosts created at 05:10:16 <-- (explorer.db)
* /etc/hosts modified at 05:12:31 <-- vi (.bash_history_root)
* /system/etc/hosts accessed at 2020-03-05 05:49:28 <-- (explorer.db)
* /system/etc/hosts modified at 2020-03-05 05:50:18 <-- (TS + external.db)
* /sdcard/Download/hosts added at 2020-03-05 05:53:35 <-- (external.db)
* /sdcard/Download/hosts accessed at 2020-03-05 05:53:50 <-- (explorer.db)
* /sdcard/Download/hosts modified at 2020-03-05 05:50:18 <-- (TS + external.db)
* Chrome - malliesae[.]com at 2020-03-05 05:55:35
* Chrome - malliesae[.]com at 2020-03-05 05:57:02
* Install cowsay w/ apt at 2020-03-05 13:31:42
* Chrome - malliesae[.]com at 2020-03-23 23:52:54
* Chrome - malliesae[.]com at 2020-03-23 23:53:03
* Chrome - malliesae[.]com at 2020-03-24 01:49:17

### Thinking Process and Answer

You might notice in the timeline that I have some extra info. The question is, when was the hosts file most recently accessed?

Since we don't have access times, I relied on the SolidExplorer database times, as well as the external.db time. We are interested in the /system/etc/hosts file since that is the real hosts file. The last time that the file was accessed, was when it was copied to the Download folder. Therefore, I said 2020-03-05 05:53:50 (also 35s). **NOPE!**

OK, so if it is not the most recent access to copy, maybe the question is asking for *any access*. Well, the hosts file had malliesae.com added, so any time the user visits that site, the hosts file will be accessed. Looking at the Chrome history, we have 2020-03-24 01:49:17 as the most recent entry for malliesae.com. Let's try that... **NOPE!**

I looked found entries in .bash_history with the user editing /etc/hosts with vi. I assume that these edits were before /system/etc/hosts was created but wanted to check anyway. .bash_history had many entries with apt and pkg. It doesn't have timestamps, but apt history does. So I compared .bash_history entries with apt history.log. All I found is that the file must have been edited between the prior times that I already knew. Well, at least things are consistent!

I took a short walk, came back, and looked at my timeline. The only timestamp that shows direct access that I've not tried is 2020-03-05 05:50:18 (the modified time). It does show access, but it seems like the hosts file was accessed after this time. Anyway, let's try: **BING!**

> Answer: 03/05/2020 05:50:18

#### Lessons Learned

* Let indexing finish before jumping to conclusions. I was too excited to start the CTF, so I started working while processing. It wasn't very efficient.
* Try the easy stuff first. The answer was the modified time of the correct hosts file. Modified does mean that access occurred, so it is correct. Instead of trying the modified time, I assumed there was access after the modification, and that is how SolidExplorer and Chrome got me off track.
