---
layout: single
title: "msft new technique to stop online child grooming"
date: '2020-01-11T11:55:58+09:00'
author: "Joshua I. James"
tags:
  - infosec
  - dfir
modified_time: ""
---


Yeah, I can understand why it's all mixed up. The reason it's not super clear is because every country has a slightly different procedure. On top of that, every case is different.

The following is a basic procedure:
Crime is identified - usually a victim makes a claim. Sometimes police detect the crime.
A case is opened, and an investigator is assigned to the case. Most likely, this investigator is not a digital forensic expert (unless their police station is small).
The investigator starts looking at the *claims* and *evidence* they already have. They also identify where additional evidence might be located.
If there it is *likely* that additional evidence is at a home/business, the investigator requests a warrant.
The judge/prosecutor looks at the current claim + evidence to decide if the argument is strong enough. They also check the scope of the warrant to make sure it's not infringing on the rights of citizens (you can't usually take whatever you want - it has to be specific).
Once the investigator gets the warrant, they prepare to go on-scene. At this stage, they will make their "team".
Since the primary investigator probably does not know digital forensics, he/she will need to bring a digital forensic expert. Usually, this is a trained officer called to join the scene investigation. If no trained officers are available, they can bring in external (civilian) digital forensic experts. Civilian's would be under contract, and have to act like police officers while on-scene. Civilians can do investigations and testify in court, but they cannot *make arrests*. Only "sworn" officers can make arrests.
The team goes on-scene for search and seizure. The digital forensic expert can collect devices and data (called "exhibits") based on what the warrant says. They cannot take anything else. HOWEVER, if investigators see something that is directly evidence, but not covered in the warrant, some countries have laws about how they can collect it.
Collected devices and data are taken into custody (Chain of Custody established), and they are taken back to the police station for storage in an evidence locker.
Eventually, the main investigator will have investigation questions relating to the digital exhibits. With these questions, the digital forensic expert starts her investigation using the devices and data that were collected.
Once the digital forensic expert finishes her report, it's sent to the main investigator. If the main investigator has more DF questions, the digital forensic expert will continue analysis. If not, the case will be finished by the main investigator.
The case is sent to the prosecutors, who decide to prosecute or not. If they prosecute, then it goes to court. At court the digital evidence can be cross-examined by an expert for the defense. The first DF expert may have to testify as an expert witness.
At that stage, the case is either finished, or is sent back for more investigation.

OK: Now that you have that basic procedure, to your questions.
* "Evidence" is a very specific word. Evidence is something that *supports a claim* in an investigation. Your phone, for example, is not evidence. If we have a claim "you called your friend today," then the [call log] on your phone is the evidence. Remember, all investigation starts with a question. Evidence is related to the question.
* Some labs don't have enough storage space for many computers. Imagine the police station is working on 200 cases, and each of them have 10 computers each! You would need a lot of room to store everything. Instead, police usually try to take only the devices they absolutely need. For everything else, they can make copies of the computers, and take the copies with them. To make copies of the computers, you have to bring forensic toolkits with you on-scene. You have to stay longer at the scene, but you don't have to bring many physical computers with you back to the lab.