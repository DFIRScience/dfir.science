---
layout: single
title: "Magnet CTF Week 2 - URLs in Pictures in Pictures"
date: '2020-10-20T00:00:00+09:00'
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

[Week 1](https://dfir.science/2020/10/Magnet-CTF-Week-1-Timestamps-of-doom.html) | [Week 2](https://dfir.science/2020/10/Magnet-CTF-Week-2-URLs-in-Pictures-in-Pictures.html)

### Getting Started

Download the Android data from [here](https://drive.google.com/file/d/1tVTppe4-3Hykug7NrOJrBJT4OXuNOiDO/view?usp=sharing). Note that the data was released October 5th, 2020 @ 11AM ET.

Calculate the hash of the suspect data:
```bash
sha1sum MUS_Android.tar 
10cc6d43edae77e7a85b77b46a294fc8a05e731d  MUS_Android.tar
```

Week 2 question:

> What domain was most recently viewed via an app that has picture-in-picture capability?

Alright, so we know that we are interested in a domain (URL) and an app that supports picture-in-picture capability.

I would typically start with a regular expression, parse out URLs, then sort by date, and go through each hit until I found a picture-in-picture-supporting app.

Instead, let's learn a bit more about *picture-in-picture* first. Take a look at Android developers [Picture-in-picture support](https://developer.android.com/guide/topics/ui/picture-in-picture) docs, and we find this little gem:

> By default, the system does not automatically support PIP for apps. If you want support PIP in your app, register your video activity in your manifest by setting  ```android:supportsPictureInPicture``` to ```true```.

So we know the app's manifest file must have ```supportPictureInPicture="true"```. This is where file indexing comes in handy. If your case is already indexed, you can run keyword searches over the file *contents*.

If I do an 'exact match' keyword search for "PictureInPicture," I get two hits. It looks like one from Twitter and one from Google. Both might need more investigation. I find it hard to believe only two apps support PIP, so let's try a substring match (partial keyword match) instead of an exact match.

Using a partial match, I get 103 results. Many are apps, but some are things like ```zram_swap```, which we can probably skip for now, but keep in mind if we need to dig a bit later.

Substring match for 'PictureInPicture="true"' returned no matches, bleah. That may have been a good filter.

Substring match for 'supportsPictureInPicture' returned two matches - both for Google Chrome. Note that I cannot see the ="true" assignment, just the configuration option in "base.vdex." According to [this post](https://source.android.com/devices/tech/dalvik/configure) .vdex is the *uncompressed* dex code of the APK. According to [this post](https://source.android.com/devices/tech/dalvik/dex-format) a dex file holds class information and data... like manifest config information, perhaps?!

Looking back at the substring search for "PictureInPicture", a lot of base.vdex and base.apk files were found, but most have directives such as ```onPictureInPictureModeChanged``` instead of ```supportsPictureInPicture```.

This leads me to the **hypothesis** (read: guess) that app manifest configurations are included in a vdex file if they are set - at least for supportsPictureInPicture.

To prove this, I should first check if anyone else has a blog or paper on vdex (I bet someone does). If not, I need to set up an Android compiler and create some app manifests with different configurations, then compile and analyze the resulting vdex to see the changes.

However, we have a specific question we are looking to answer, which helps quite a bit. In this case - if my hypothesis holds - then Chrome supports picture-in-picture mode. I can verify that it does on my Android device.

Since Chrome was the only PIP app that returned with the result ```supportsPictureInPicture```, and it can connect to domains, Chrome is a good candidate for the target app.

In that case, all we need to do is check the Chrome history. In this case, our target history file is: ```/data/com.android.chrome/app_chrome/Default/History```. Parsing this file with your favorite history parser should reveal ```http://malliesae[.]com/investor-page/```  as the most recently accessed URL at 2020-03-23 23:53:22 UTC. However, we want only the domain and not the full URL. So we get malliesae[.]com.

**NOTE** I the URL above has been "defanged" with [.], so someone doesn't accidentally go to the URL.

### Answer

Entering that domain into the [CTF system](https://magnetweeklyctf.ctfd.io), and **BING!** Correct. 

> Answer: malliesae.com

### Lessons Learned

Last week I said, "try the easy things first." You can also see from the [week 1](https://dfir.science/2020/10/Magnet-CTF-Week-1-Timestamps-of-doom.html) post that I already knew the domain. Most forensic tools will automatically parse out web browsing history. In fact, browsing history was already parsed in my tool. I could have just clicked on it, scrolled to the most recent one, and found the domain. I would have been correct. Sometimes, the problem with trying the easy thing first is that you don't learn anything new.

I know how to parse out Chrome history. I do it all the time. I don't know much about vdex files. By adding the PictureInPicture element to the question, I now need to show two things: this app supports PIP, and this is the domain. Did I need to go through all that trouble? Nope. I could have *tried the easy thing first*. But did I learn something from taking the long way around? Sure did.

Is the long way around practical in real investigations? Well, **maybe**. In real investigations, we don't have a CTF platform to confirm the answer. If we are just looking at the results of our tools *without strongly answering all relevant questions* we might be coming to wrong, or incomplete, conclusions.

So I'll revise last week's conclusion: *Try the easy things first, but make sure all conclusions are strongly supported.*