---
layout: single
title: "Magnet CTF Week 3 - The case of the spoiled S. Cargo"
date: '2020-10-27T00:00:00+09:00'

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

Week 3 question:

> Which exit did the device user pass by that could have been taken for Cargo?

OK, so this week we have a bit of a riddle. Two things we don't know are "what is exit" and "what is Cargo"? We might be looking for a highway exit, subway exit, bus station exit. Cargo might be the cargo like you ship, but then why would it be capitalized? Possibly the name of a location?

In the Cache Up CTF Wk 3 Challenge video, Jessica [air quoted](https://youtu.be/DMzs5YzyABc?t=623) "Cargo." Like an idiot, I focused on the air quotes more than the hint she gave right before that -> we need to check a [past webinar](https://www.magnetforensics.com/resources/mobile-artifact-comparison-webinar-recording-oct-7/).

I decided to start by taking the question literally, with a particular focus on Cargo. Notice the word Cargo is also capitalized. So it could be a name. Without further context, I'm going **assume** (read - probably wrong guess) an exit (highway exit?) that a user passed that could have lead to a "cargo zone".

Did I mention that the *week 3 trivia question* had to do with snails? That will be important shortly.

### Incorrect Thought Process

If we take the question literally with no additional context, we are likely looking for location information. For example, location meta-data from the device from JPEG EXIF data can show where the user was. Loading up the EXIF location data, we see two countries.

Both countries have the user at airports, near train stations, and close to sea freight. A random zoom-in on the U.S. shows JFK airport. Cargo exits usually are before the airport. Following the airport's JFK expressway, the first road we get to is the most magical answer.

![S Cargo Rd.](/assets/images/posts/2020SCargo.png)

Get it? S Cargo Road. Snails. Air quotes. ([Escargot](https://en.wikipedia.org/wiki/Escargot)) It's the perfect answer to a snail-filled adventure. However, it's also the wrong answer. **NOPE!**

At that point, I realized we only have three tries this week - not looking good.

Because I was rushing (again), I decided to stay on the JFK Airport track. I used Google Maps to look for the Cargo exits. One problem is that exit signs in the U.S. may be mile-markers or local exit names. In the case of JFK, it could be 269 or Exit B.

Alternatively, there is also the Van Wyck Expressway. It uses letter exits as well. On both expressways, Exit C takes you to the Cargo area. So I tried "C." **NOPE!**

Down to one try left. At this stage, I can either stick with JFK and try "Exit B," or move to Norway (Olso Airport). Completely forgetting about the webinar hint, I decided to stay with JFK. Exit B! **NOPE!**

Cry cry.

### An additional chance

In the middle of the week, we were given one additional chance. Before that, I watched the [webinar](https://www.magnetforensics.com/resources/mobile-artifact-comparison-webinar-recording-oct-7/) which talks about location information from EXIF data + ```gmm_storage.db```. ```gmm_storage``` was identified as location data in quite a few sources, but I couldnt find anything about the BLOB structure. That means, no parser. Instead, I ended up using strings and manually parsing the resulting queries for location information.

Based on images (EXIF + content) I was able to create the following timeline:

* Train in NY towards JFK airport (EXIF)
* Take a picture of a shipping company (EXIF)
* Not *exactly* sure how suspect got to JFK
* Fly from JFK to Olso, Norway (EXIF)
* Take a shuttle bus South from Oslo Aiport to Oslo city (picture with no EXIF GPS)
* Stay in a... hostle / homestay (EXIF)
* Sightsee around Oslo (EXIF)
* Train from Oslo West (EXIF + gmm_storage.db)
* Train to Bergen after some stops (EXIF + gmm_storage)
* Sightsee around Bergen (EXIF)
* Shuttle to Bergen Airport (picture)
* Flight out (trail ends)

I checked if there was a place called "Cargo" in Norway or New York, and returned nothing. Bergen airport doesn't seem to have a seperate exit for the cargo area. That leaves Olso airport.

From Oslo Aiport, the suspect seens to have taken Lufthavnvegen South. If you take Lifthavnvegen Exit 2 from the airport, you get to E16 and come to:

![Cargo](/assets/images/posts/2020Cargo.png)

So... Exit 2? **NOPE!**

### Lessons Learned

* This week was difficult because I was missing the context of the question. From my thinking, you can see that I don't even know *which country* the question refers to if it is even really location-based at all. **Context is king**, and I didn't do enough prep to build context.
* I also - in a way - learned about the frustration of time limitations. The three chances this week is a resource limit. Once you hit that limit, you are off the case. I hit the limit early and still thought about the case with no way to verify what I was finding. Instead of thinking about (stressing about) what the answer could have been, take some exercise, clear your mind, and move on.
