---
layout: single
title: "Modular artifact scripts coming to iLEAPP"
permalink: /:year/:month/:title
date: "2022-08-12T16:58:28-05:00"
tags:
  - dfir
  - infosec
  - ileapp
  - aleapp
header:
  og_image: "/assets/images/logos/dfir_card.png"
  image: "/assets/images/posts/headers/GenericCode.jpg"
  caption:
modified_time:
---
 
[kviddy](https://twitter.com/kviddy) has been pushing some great core updates to [ALEAPP](https://github.com/abrignoni/ALEAPP). Specifically, artifact scripts are now self-contained. This means that script authors no longer need to update an artifacts list. Instead they can write their parser script, drop it into the scripts folder, and DONE! Awesome.

This change also makes it easier to create "run filters" based on the datasets you are processing. For example, say you are only interested in calendar and sms artifacts for most of your cases. Now you can create a parsing filter to just run selected modules. One click and done! This is extremely useful since the supported artifacts in all LEAPPs is getting very large.

These updates are already rolled out to ALEAPP v3.0+. Go check it out!

These great features, however, were not pushed to iLEAPP and others yet, so I've started working on that. iLEAPP modular artifact scripts based on kviddy's work was [submitted](https://github.com/abrignoni/iLEAPP/pull/325) this week. Currently working on the selectable script filters and updating everything in RLEAPP.

After that, I want to start working on LEAPP core optimization. I suspect the new way of calling scripts may see better performance with concurrency or multiprocessing. Needs more testing.

