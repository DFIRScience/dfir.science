---
layout: posts
title: 'How To - Introduction to Autopsy for Digital Forensics'
date: '2017-02-01T12:04:28+09:00'
author: Joshua
tags:
- dfir
- digital forensics
- Autopsy
- Autopsy 4
- The Sleuth Kit
- How to
modified_time: '2017-02-01T12:04:28+09:00'
---

[Autopsy](http://www.autopsy.com/) is a free, open source digital forensic tool that supports a wide range of add-on modules. Available APIs allow an investigator to easily create their own modules using JAVA or Python. With Autopsy 4, there are a lot of new features - including 'team collaboration' - that make Autopsy extremely powerful.

I've been using Autopsy myself for a long time, and have been tracking the development of the new Autopsy GUI. I've also been using Autopsy in practical investigator training as an *almost* complete replacement for much more expensive tools.

Autopsy is very easy to get started with. Just [download](http://sleuthkit.org/autopsy/download.php) the software. Unfortunately, it is only for Windows right now. It seems possible to compile on Linux, but I've not had any luck. Once you download the installer, make sure you [verify the installer](https://DFIR.Science/2015/07/how-to-using-gnupg-to-verify-data-using.html). Once verification is complete, install the tool like usual.

One thing to be aware of is that Autopsy does not have the ability to create disk images. If you are using Windows you can see [this](https://DFIR.Science//2016/11/how-to-forensic-acquisition-in-windows.html) post about acquiring a digital forensic image using FTK Imager. If you are using Linux you can see [this](https://DFIR.Science//2016/10/how-to-forensic-acquisition-in-linux_31.html) post about acquiring a disk image using Guymager. If you are connecting a disk directly see this video on [hardware write blockers](https://DFIR.Science//2016/10/how-to-forensic-data-acquisition.html).

You can also check out the book [Practical Forensic Imaging](https://amzn.to/2YZqvIx) by Bruce Nikkel.

Ok, so once you have a disk or disk image you would like to analyze, start up Autopsy. You will be asked to create a new case. Think about *where* you want to save your case. Try to keep cases on a dedicated hard drive. Avoid the same disk that your system file are running from. We try for complete separation, when possible. Structure also matters, which we will talk about in a later post.

After case creation, you will be asked for the disk/image that you would like to analyze. See the video below for more information. Finally, you will be allowed to select each of the ingest modules that you would like to run against the disk image. If the modules are not already configured, you can configure them here. You can also configure them later and re-run the configured module against the disk image. See the video for an explanation of all of the major default modules.

{% include responsive-embed url="https://www.youtube.com/embed/WB4xj8VYotk" ratio="16:9" %}

Processing can take a long time depending on your computer / servers processing power, the size of the suspect data, the type of suspect data, the storage device and speed of the connection, among others. You can examine data in Autopsy as it is processing in the background. Your computer will likely be much less responsive, and computers that do not have much memory will be very slow. Computers with 4GB of RAM sometimes crashed when dealing with 20GB+ disk images. With Autopsy - and most forensic tools - the more RAM your computer has, the better.

As the ingest modules process the data, information will show up in the left-hand tree. For more details about what each type of information potentially relates to, please see the video below.

{% include responsive-embed url="https://www.youtube.com/embed/FJqoUakfmdo" ratio="16:9" %}

That is it for basic data processing using default ingest modules in Autopsy 4. It is a very easy to use, but power tool that is suitable for many types of investigations.
