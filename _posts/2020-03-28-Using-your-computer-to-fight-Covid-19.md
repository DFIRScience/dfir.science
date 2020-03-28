---
layout: single
title: "Using your computer to fight COVID-19"
date: '2020-03-28T08:01:45+09:00'
author: "Joshua I. James"
tags:
  - security
  - computing
  - boinc
modified_time: ""
---

You're stuck at home, maybe going a little crazy (here are some [tips](https://www.thorn.org/blog/thorn-tips-working-from-home-remote/) to help with that). Maybe you are starting to feel frustrated.
I know I am.

If you want to fight COVID-19 (and other diseases), but also must stay home, let me introduce you
to the [Berkeley Open Infrastructure for Network Computing](https://boinc.berkeley.edu/) (BOINC). 
BOINC is software for your computer or smartphone that lets you donate processing power to a project 
of your choosing.

**NOTE:** If you don't want to install software, you can help by playing games such as [Eterna](https://eternagame.org) and [Fold.it](http://fold.it/).

For BOINC, there are [many great projects](https://boinc.berkeley.edu/projects.php) you can join. For now, we want 
to focus on COVID-19. There are currently [four projects](https://www.boincusa.com/forum/index.php?threads/coronavirus-covid-19-projects.1623/#post-4175) running experiments on COVID-19. Let's add them!

### Getting BOINC

You will need the BOINC client to run any of the projects. The BOINC software manages the projects, and also allows you to control when you donate your computer's processing power. For example, it can run projects only when you are not using the computer.

* Windows Users
  * go to the [Downloads page](https://boinc.berkeley.edu/download.php). You can either get
BOINC + VirtualBox or just BOINC. BOINC + VirtualBox allows you to run more projects, but either will work today.
* Linx Users
  * The easiest way to install is with your package manager. On Ubuntu '''sudo apt install boinc boinc-virtualbox boinc-client-nvidia-cuda'''
* Android Phones
  * Search the Play Store for BOINC from *Space Science Laboratory, U.C. Berkeley*, or [click here](https://play.google.com/store/apps/details?id=edu.berkeley.boinc)

### Adding a project

When you first start BOINC on Windows and Linx, BOINC Manager will pop-up a project list. If not, click the "Add Project" button. First, choose Rosetta@Home, and click Next. You will be asked to create an account with an email address. This is to keep track of your project list and processing stats. It also lets you set project settings remotely. I've been running
projects for years, and I never had a problem with spam (related to the projects).

![BOINC Manager Add Projects](/assets/images/posts/BOINC01.png "Adding projects in BOINC manager for desktop")

Two projects you can add directly from the list are Rosetta@Home and GPUGRID. Folding@Home and TN-Grid require some special config.

Android is similar. When you first open BOINC, it will show a list of projects. You can choose more than one project at a time. Select your projects, click 'Continue,' enter your email and a password, then the projects... probably won't start.
By default, your phone needs to be charging for BOINC to do any work. See below on how to change run settings.

![BOINC Manager Android Projects](/assets/images/posts/BOINC02.png "Adding projects in BOINC manager for Android")

After you create an account, the project should be added. That's it! You can just let it run. You may want to control when your computer processes.

### Changing project run settings

If BOINC is installed on your main computer or mobile device, you probably don't want it running all the time. For example, while you are working or running on battery power.

#### Desktop

For Windows/Linux/OSx the default view is "Simple View." It doesn't show much. Let's switch to "Advanced View." Click "View" and "Advanced View." Next, click "Options" and "Computing Prefrences." Using these preferences, you can control exactly when and how much processing power is used.

![BOINC Manager power settings](/assets/images/posts/BOINC03.png "BOINC power settings")

I usually check the following:

* Suspend when the computer is on battery
* Suspend when the computer is in use
* Suspend GPU computing when computer is in use
* 'In use' means input in the last **10** minutes

Normally, those settings are good enough for it. It won't process on battery, and won't run when I'm working. It will run at lunch, or long meetings, or if I just leave the system on overnight.

If that is not enough, there is also a "Daily Schedules" tab. You can use daily schedules to set the day and time that a project will run.

Once you are finished, click "Save."

#### Mobile

On BOINC for Android, once you've added the projects, click the top right (hamburger), and select "Preferences." I use the
following settings:

* Autostart
* Pause computation when screen is on
* Transfer tasks on WiFi only
* Power sources: Wall, USB, Wireless (not battery)
* Min battery level = 90%

Basically, the defaults should make sure you don't run tasks unless your phone is charging and on WiFi.

### Conclusions

It might not be much, but you never know. Donating some computing power might speed up vaccine development. The best part is that you can make a difference while still staying home and flattening the curve.