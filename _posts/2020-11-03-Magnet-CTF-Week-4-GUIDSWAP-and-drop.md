---
layout: single
title: "Magnet CTF Week 4 - GUIDSWAP and drop"
date: '2020-11-03T13:00:00+09:00'

tags:
  - infosec
  - dfir
  - CTF
  - Magnet
modified_time: ""
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

Week 4 question:

> Chester likes to be organized with his busy schedule. Global Unique Identifiers change often, just like his schedule but sometimes Chester enjoys phishing. What was the original GUID for his phishing expedition?

Oh, that Chester! So again, we have a bit of a riddle. We are looking for 1) scheduling information that 2) has Global Unique Identifiers (GUID), that 3) change based on some action.

### Hypothesis 1

**H1**: Whatever calendar app is installed. I am guessing **H1** because it's a likely place for some schedule info.

I know that some calendar information for Android can be found in ```com.android.providers.calendar``` -> ```databases``` -> ```calendar.db```. However, I don't remember seeing the event data. Let's check it out!

The ```calendar.db``` "Calendars" table shows Chester's main account and some basic calendar info. At least we know he has a calendar registered, and it looks like it is set to sync (sync_events = 1).

The "Events" table is empty. Awww. Notably, there is an _id column, but I'm not sure if that would be a GUID anyway.

There is also ```com.google.android.calendar```. In the ```files``` directory, we can see a sync log (sync_history). In the ```databases``` directory we can see ```cal_v2a``` and ```cal_v2a-wal```. Surprisingly, I couldn't find much about these files online.

Looking into the ```cal_v2a``` database, the Calendars table shows Chester's account. The Events table, again, is empty—no indication of a GUID for EventId.

```cal_v2a-wal``` seems to contain a lot of information about events for settings from the calendar.

```
102065892684377886557king.chester.802@gmail.com
king.chester.802@gmail.com
king.chester.802@gmail.com"
UTC*
1579627255066000R
7A  102065892684377886557king.chester.802@gmail.com
  102065892684377886557
4dq]
102065892684377886557hideWeekends
hideWeekends
false
```

Some of these, like 1579627255066000, are timestamps. I would bet this is the default setting information for the calendar. I didn't see anything that looked like an event and no GUID.

Taking another quick look around, I don't see any other calendar-specific apps. So I'm going to mark **H1** *not supported*.

### Hypothesis 2,3

**H2** an alternative app has scheduling capabilities that use GUIDs for events.

While investigating **H1**, I came across a file ```000003.log```. Specifically, I did an "Exact Match" keyword search for "Calendar." This log file contains a list of calendar names, dates, and timestamps. As well as GUIDs!!

That log is located in ```com.evernote``` - OH OH! Taking a look in the ```databases``` folder, we find ```user213777210-1585004951163-Evernote.db```. This DB contains the table "notes", where we find Phishy Phish phish with guid "c80ab339-7bec-4b33-8537-4f5a5bd3dd25".

It looks like **H2** is confirmed, and the app is "evernote". **H3** is that this note GUID is the *new* id, and we need to find the old id.

Using the first part of the GUID (c80ab339) as a substring keyword search will probably return only a few false positives, if any. Indeed, we get 6 hits. One of them is ```log_main.txt``` which sounds pretty interesting! log_main.txt is found in ```com.evernote``` -> ```files``` -> ```logs```.

Our first hit with c80ab339 shows an entry for GUIDSWAP:

```
2020-03-23 20:08:58.178 D/SyncService: {SyncServiceWorker-2} - GUIDSWAP: Uploaded new note (7605cc68-8ef3-4274-b6c2-4a9d26acabf1 -> 
c80ab339-7bec-4b33-8537-4f5a5bd3dd25)
```

If I didn't know any better, I'd say that was the modification of a GUID. It looks like GUID 7605cc68... was changed to c80ab339... and uploaded.

Trying ```7605cc68-8ef3-4274-b6c2-4a9d26acabf1``` as an answer... **BING!**

### Lessons learned

* Even if you start in the wrong place, it gives you intelligence for the next stage.
* When in doubt, keywords.