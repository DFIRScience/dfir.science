---
layout: single
title: "Hypothesis based problem solving with Bash and Imagemagick"
date: '2019-12-23T20:23:57+09:00'
author: "Joshua I. James"
tags:
  - programming
  - imagemagick
  - tutorial
  - analysis
modified_time: ""
---

{% include video id="ETCAoVpdPOA" provider="youtube" %}

This is NOT a computer vision tutorial. In this video, we walk through problem-solving using programming. As a test case, we extract color features from GIF frames to detect strobe effects. We use Imagemagick's identify tool to look for interesting patterns that we can use to make the GIF strobe detector.

This video is a bit longer because we walk through the entire problem, from identification to testing, to software creation. We write the POC logic in a bash script in Linux.

Give your hypothesis about GIF detection features in the Youtube comments!

[Download](https://github.com/jijames/GIFStrobeDetect) the script and test data. Try to detect features from the other to GIFs and send a pull request on Github.

### Forensic Implications

Investigations are about starting with a problem, identifying possible solutions, and testing those solutions. In this video, we *investigate* GIF features to see if we can detect GIFs that have the feature of a strobe effect. When starting with a problem, whether it is an investigation or a programming problem, the thought process is the same. These types of practice can help keep you thinking in terms of 'hypothesis -> test -> document' processes.

I encourage you to try the same process to solve GIF detection for the final to GIFs.
