---
layout: single
title: "Getting started in Digital Forensics"
date: '2017-12-16T12:50:17+09:00'

tags:
- infosec
- dfir
- Education
modified_time: '2017-12-16T12:50:17+09:00'
---

A lot of people have asked how to get started with digital forensics. It's great that so many people from so many different places are interested. There are many different paths available. To try to help aspiring digital forensic scientists, I put together the following recommendations for a good theoretical and practical background.

## The Basics
First, learn how operating systems work. You might know how to use [Windows](https://www.microsoft.com/en-us/windows), but have you really explored it? Can you explain how clicking on an icon [starts a program](https://en.wikipedia.org/wiki/Execution_(computing))? Play around with other operating systems too, like [OSx](https://www.apple.com/) and [Linux](https://www.debian.org/)<sup>[1](#linux)</sup>.

  * A good beginner book on operating systems: [Operating System Concepts](http://amzn.to/2yGiZ8d) - Currently 9th ed.
  * A good beginner certification on operating systems: [CompTIA A+ Certification](https://certification.comptia.org/certifications/a)

### Virtualization
Learn how to use virtualization software. This software will let you create many virtual computers that you can test/play with. You won’t have to worry about breaking your own computer, and resetting a virtual machine is easy. Learn how to use "snapshot" features.

  * I recommend [Virtualbox](https://www.virtualbox.org/wiki/Downloads) (free)
  * Once you have Virtualbox, I recommend installing [Linux Mint](https://linuxmint.com/download.php) in a virtual machine (also free).

### Command Line and Basic Forensics
Once you have Linux installed in your virtual machine, have a look at the [Linux Leo Beginner’s Guide](http://www.linuxleo.com/) to learn how to use Linux command line and some basic digital forensic tools. You can finish the guide in about 1 week.

Once you know the basics of Linux command line, have a look at [Windows command line](http://www.makeuseof.com/tag/a-beginners-guide-to-the-windows-command-line/). If you have Windows 10, you may want to start directly with [Windows Powershell](https://www.infoworld.com/article/3126427/microsoft-windows/go-pro-the-power-users-guide-to-powershell.html) Why all this command line (CLI)? Learning basic cli can help you understand how computer systems work. You'll also be able to do some tasks much faster on the CLI.

At this point you should know the basics of operating systems, be able to use VMs, have basic knowledge of Windows and Linux command line. If you have that, you have a pretty strong base for computer science / engineering related areas.

## Programming
Programming is [not necessary](http://www.sciencedirect.com/science/article/pii/S1742287617300282) to do digital forensics, but it will help you a lot (as well as in other fields).

There are basically two types of programming languages; scripted and compiled. Scripted usually runs slower, but tends to be faster to write, fix and easier to learn. Compiled programs run faster and are usually more efficient. General programming concepts are the same for almost all languages. Knowing a scripting language and a compiled language is useful.

Personally, the languages I use the most (in order) are:

1. Linux Bash Scripting (almost daily, easy): [tutorial](https://linuxconfig.org/bash-scripting-tutorial)
2. Python scripting (many projects, easyish): [tutorial](https://developers.google.com/edu/python/)
3. HTML5/CSS3/Javascript (many projects, easy): [tutorial](http://www.w3schools.com/html/html5_intro.asp) also see [Electron](https://electronjs.org/)
4. Go lang (compiled, medium difficulty): [Intro](https://www.golang-book.com/books/intro), [Book](http://amzn.to/2AUMg5a)

I think most investigators know at least a little bit of some of these languages. Other popular languages are:

* [Rust](https://www.rust-lang.org) ([Book](http://amzn.to/2yGE9mv)) / [C](http://amzn.to/2AS0nYG) / [C++](https://developers.google.com/edu/c++/) (Start with Rust)
* [Java](https://www.ibm.com/developerworks/java/tutorials/j-introtojava1/index.html) - I don't like it, but a lot of people use it.
* [Perl](https://www.perl.org/) - scripted, easy, I think Python kinda beat Perl in forensics

## Cybercrime and Digital Forensics
There are a lot of books on digital forensics. One of my favorite books is ['Digital Evidence and Computer Crime'](http://amzn.to/2CE5WHu), but it is getting a bit dated. The digital forensic practice sections is still very relevant.

I recommend looking for videos, tutorials and challenges online. Some resources:

  * My youtube channel: [https://www.youtube.com/DFIRScience](https://www.youtube.com/dfirscience)
  * Follow the #DFIR and #infosec tags on [Twitter](https://twitter.com/search?q=%23DFIR&src=tyah) (Follow [me](https://twitter.com/DFIRScience) on Twitter)
  * [Cybrary](https://www.cybrary.it/) has some good information security and (a few) forensics lectures
  * [SANS Digital Forensics](https://digital-forensics.sans.org/) - Great resources, super expensive

You need to learn:

1. Data preservation (various data sources)
2. Data acquisition (various data sources)
3. Forensic documentation (standards of court & chain of custody)
4. Basic data processing (basic investigation process)
*   For basic data processing, I recommend the tool [Autopsy](http://sleuthkit.org/autopsy/) (free, a very powerful tool that is also easy to use).

Once you know have a good idea about what that means, then you can focus on different types of analysis. There are actually a lot of different 'types' of digital forensics. Very basically, the areas are<sup>[2](#areas)</sup>:

* Computer forensics
* Mobile device forensics
* Network forensics
* Forensic data analysis
* Database forensics

Areas that are extremely related, but are either not ‘forensics’ per se, or are combination areas:

* Malware analysis
* Memory forensics
* Cloud / IoT forensics
* eDiscovery
* Vehicle forensics

While most investigators know a little about each area, many focus on a particular specialty. Almost every investigator can do a basic analysis of a computer and probably a mobile device. I strongly recommend starting with computer forensics, then memory analysis, then mobile forensics then network. That will give you a lot of the background you need to do the other areas.

### Challenges (Practice)
Of course, you need to practice digital forensics to understand it. Recently a lot more forensic challenges have been released. I encourage you to participate in these as much as you can.

* [DFIR.Training](http://www.dfir.training/index.php/tools/test-images-and-challenges)
* [Forensic Focus](https://www.forensicfocus.com/images-and-challenges)
* [SANS Challenges](https://digital-forensics.sans.org/community/challenges)

## Ask questions
An of course, the best way to learn is to **ask questions**. Most dfir and infosec people I know are willing to answer some questions and help beginners. There are, however, bad questions.

The most common question I get is "tell me how to hack." This question is so general that it can't be answered. It also shows that you didn't take the time to [read the thousands of resources](http://lmgtfy.com/?q=how+to+hack) online about hacking. A similar question is "how to do digital forensics."

When **asking questions** do a quick search first to see if the answer is already online. If you found an answer, but don't understand it, *great*. Send your question plus a link to the answer and ask for clarification. I would love to help you with a problem you are stuck on. The more specific you are with questions, and the more effort you put in to finding the answer, the more likely someone is to help you solve your problem.

Where to ask questions? Well you can [contact me](https://dfir.science/Contact/). I also recommend [Forensic Focus](https://www.forensicfocus.com/). A lot of the community is also on Twitter #dfir. Also, [StackExchange](https://security.stackexchange.com/) is sometimes helpful.

## Finally
This post is about starting digital forensics. A lot of it was really about 'starting technology'. Notice I only mentioned one certification (A+). Certifications can be helpful, but they are also expensive. Before you commit to a lot of certifications, I'd recommend getting basic OS, computing and programming skills first. There are a lot of free resources on line. Once you have the basics, then think more about certifications you are interested in based on need and where your interests are.

I hope these resources help you start thinking about how you can get into digital forensics. Of course, there are many ways to begin. Digital forensics requires a lot of study just to keep up with the current technology. It's not impossible though, especially if you have the basics down.


###### <sup><a name="linux">1</a></sup>I'm going to get in trouble if I only mention Debian Linux. Check out some others too: [Ubuntu](https://www.ubuntu.com/), [RedHat](https://www.redhat.com/en), [Gentoo](https://www.gentoo.org/), [Arch](https://www.archlinux.org/), [Qubes](https://www.qubes-os.org/); [Unix](https://en.wikipedia.org/wiki/Unix): [FreeBSD](https://www.freebsd.org/), [Solaris](https://www.oracle.com/solaris)

###### <sup><a name="areas">2</a></sup>I'm also going to get into trouble with categories of forensic science. I consider the first list 'core' concepts that an investigator should be aware of before they can understand the second list.
