---
layout: single
title: "How to add artifacts to ALEAPP"
date: '2021-11-09T17:10:41-06:00'
tags:
  - infosec
  - dfir
  - android
header:
  image: /assets/images/posts/headers/android.jpg
  caption: "Photo by [Rami Al-zayat](https://unsplash.com/@rami_alzayat?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/fast?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)"
modified_time: ""
---

The Android Logs Events And Protobuf Parser (ALEAPP) is a fast triage tool for Android forensic processing. ALEAPP is relatively modular in design, and it is easy to add additional artifacts. We show how to plan out and add a basic artifact (module) to ALEAPP. This method is similar for iLEAPP, WLEAPP, and other *LEAPP projects.

To add a new artifact, you will need a basic understanding of Python. Next, you will need to identify the data you want to process, as well as its structure. In this example, we show how to process an XML file on an Android phone dump.

You will need the file name and location of the target data. You will then add your module information and the target data location to the file 'ilap_artifacts.py'. The ilap_artifacts file registered your artifact and controls target file search and routing.

Next you will add your artifact script to ALEAPP - scripts - artifacts - [artifact name].py

This is the script that will be called when ALEAPP finds a file that matches the query described in ilap_artifacts.py.

Your artifact has three main parts:

1. Imports and ALEAPP default functions
2. The target data parser
3. Reporting

Also, consider adding a header with information about the artifact's author and version number/date.

Imports and reporting can be copied from other artifacts or the template linked below. The parser, however, will be specific to your target data type.

{% include video id="mM4rbFh4rqg" provider="youtube" %}