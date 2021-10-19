---
layout: single
title: "Downloading and adding NSRL hash sets to Autopsy"
date: '2020-11-24T22:22:04+09:00'

tags:
  - infosec
  - dfir
modified_time: ""
---

Hello Jerry,
They don't make it very easy for some reason.
This is the link to the download page with all hashsets.
https://www.nist.gov/itl/ssd/software-quality-group/national-software-reference-library-nsrl/nsrl-download/current-rds


The one you probably want is "Modern RDS (minimal)". The direct link to the RDS minimal zip is here:
https://s3.amazonaws.com/rds.nsrl.nist.gov/RDS/current/rds_modernm.zip


The zip files are big.
Extract everything in the zip file to your fastest hard drive. Inside the zip file you will have a (very large) text file called NSRLFile.txt. When you are adding hashes in Autopsy, chose the NSRLFile.txt to add. The first time you add it, Autopsy will make an index of the file. That process will take a while, but you only need to do it once.


Also, when adding NSRL you are adding "Known" or "Known good" file hashes. You do not want Autopsy to flag files from the NSRL. Most likely, you want autopsy to hide any matches.