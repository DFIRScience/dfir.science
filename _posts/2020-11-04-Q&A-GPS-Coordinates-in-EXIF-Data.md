---
layout: single
title: "Q&A: GPS Coordinates in EXIF Data"
date: '2020-10-29T22:16:37+09:00'

tags:
  - infosec
  - dfir
modified_time: ""
---

I was just watching your video 8.3 about Autopsy, and specifically about
the JPG EXIF metadata.

I just completed a Python program that iterates over a directory, and looks at
all JPG images.  If they have EXIF data and​ GPS data is present, it uses
Python geopy package to try and get the address associated with it.   It
also allows the user to specify a locality name.   This effectively lets you
examine a file system and see, when available, if a photo was taken in
the target town or city.

I had fun doing this, but found that GPS data is not only not always present,
it is not always accurate.  For example, a picture I took where I am now
(Narragansett, Rhode Island, USA), did not have the correct latitude ref,
so it gets translated by geopy as being in Chubut, Argentina!

Still, I look at programs like this as "best effort"... as long as you understand
the limitations, it may still help you.

FWIW, this little Python program can be seen at my Github account,
at https://github.com/mitchcc/python/photoloc

My real question for you comes from your video.  More sophisticated EXIF
programs, such as exiftool, allow you to change the metadata.   Do you
know if programs like Autopsy have a way to detect this?   I think that most
operating systems specifically do not allow you to do this for things like
file creation and last modification time, but since this is just file data,
I couldn't see how the OS could prevent someone from trying to disguise
the EXIF data.

I know you are busy, and I appreciate having someone to periodically
chat with.  

I will close by telling you that I did get an interview for next week for
an admin position in the Pinellas County (FL) Sheriff's office Digital
Forensics lab....   this is what is driving my self-education!

----


Apologies that it was so long to respond to your email!
Your python GPS program sounds great! Thanks for that.

You are exactly right that EXIF information is "application meta-data." Each application can choose whether to edit it or not. EXIFTool allows editing. Many image viewers now allow editing exif information as well.

File creation and last modification time (in the file system) is "file system meta-data." This is managed by the FS/OS, not by external applications.

Long story short - the OS does nothing to protect the integrity of EXIF data. It leaves it to any app that wants to read/write the data.

Also, you are correct in your observation about GPS not being accurate. If someone turns GPS on it takes *a while* for the GPS to calculate the location. All GPS information will be off until then. Great observation! The problem is, we don't usually have any way of knowing how accurate the GPS position is at the time. iPhones keep some of that info, but I don't think it is added to EXIF.

Sounds like you are on exactly the right track.

How did the Forensic Lab interview go? Based on your email, I would expect it to go very well!


