---
layout: single
title: "warrants"
date: '2020-01-11T11:55:58+09:00'
author: "Joshua I. James"
tags:
  - infosec
  - dfir
modified_time: ""
---

The text book it says you don't need a search warrant if its computers that belong to a company.
You never need a warrant if the owner of the device gives you permission.
Most of the time a company will give you permission to collect a suspect's data if the company is not otherwise involved. If the company does not give you permission to collect data, you must get a warrant.
If a suspect gives you permission to collect data, you do not need a warrant. We assume that a suspect will not usually give permission.
How is getting evidence from a computer that belongs to a company he works for(at his workplace) different than getting evidence from his home computer?
The company owns the computer. Employees just "borrow" the computer from the company while they are at work. The company has full control of the device (with restrictions on privacy).
What if that company has confidential things in their computers and don't want you to copy them?
The company can give you permission only to copy certain things and not others. If you need to copy things, and they did not give you permission, you need a warrant.
what if that company has their own digital investigators do you just let them do the job and they can report their findings to police?
If the company is not suspected to be involved in the case, the company investigators can provide acquired data + documentation. The police should never rely on the findings of others. It can be included, but not trusted without verification.
If a company is providing acquired data, the police should also request a preservation order for the data so the company does not delete anything related.
If his work computer is turned on, it says to leave it on and capture the data from the ram but it doesn't say how to do it
You can do it on Windows with FTK Imager lite. Use FTK imager to practice on your own computer: https://www.youtube.com/watch?v=1OxR4KLj-4I
https://accessdata.com/product-download/ftk-imager-version-4-3-0
how do you know if this software that deletes the data exits on his computer?
Shutting down the computer could cause programs to run and delete files. However, it's more likely the suspect is using full disk encryption (FDE). If you shut down, recovering data is impractical.
If the computer is on, check to see if there are any obvious programs running in the bottom right corner. Then take a quick look at the start menu to look for encryption or cleaning software. If there is nothing suspicious, you could check for installed programs (uninstall apps - DON'T UNINSTALL ANYTHING). While you are in Windows settings, check to see if Bitlocker (full disk encryption) is turned on.
If there are no suspicious looking programs, and bitlocker or other encryption is not on, it is probably safe to power off (not shut down) the computer.
Power off by pulling the power cable on desktop computers, or holding the power button on laptops. Never go to Start -> Shutdown.
If it looks like there are cleaning programs or encryption enabled, you can do a live disk acquisition - also with FTK Imager.
If there is some data that you absolutely see is evidence in your case, it is always safer to acquire that data before trying to power off.
Live Data Forensics very much depends on the situation. You must have a good reason for everything you do, document well, and be able to describe what changes you made to the system. 
P.S. When you talk about a suspect, you usually say "he/his". When starting a case, never assume the sex or age. In some cases I thought "the suspect must be a young man" but it turned out the suspect was an old woman. Never assume. Always find evidence.