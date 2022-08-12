---
layout: single
title: "General overview of investigation process"
date: '2020-03-25T14:41:32+09:00'

tags:
  - infosec
  - dfir
  - investigation
modified_time: ""
---

Many people that begin learning digital investigation, especially formally, seem to learn technical issues before the criminal investigation procedure. The problem is, without a general understanding of investigation procedure (basically), digital investigation doesn't fit in any context. It's important to establish that context - either criminal or civil procedure - before diving into digital investigation procedure.

First, every country has a different procedure. On top of that, every case is different. The following is *very basically* how investigation procedure works.

1. Crime is identified - usually, a victim makes a claim. Sometimes police detect the crime.
2. A case is opened, and an investigator is assigned to the case. Most likely, this investigator is not a digital forensic expert (unless their police station is small).
3. The investigator starts looking at the *claims* and *evidence* they already have. They also identify where additional evidence might be located.
4. If it is *likely* that additional evidence is at a home/business, the investigator requests a warrant.
5. The judge/prosecutor looks at the current claim + evidence to decide if the argument is strong enough. The judge/prosecutor also checks the scope of the warrant to make sure it's not infringing on the rights of citizens. (You can't usually take whatever you want - it has to be specific.)
6. Once the investigator gets the warrant, they prepare to go on-scene. At this stage, they will make their "team."
7. Since the primary investigator is probably not a digital forensics expert, he/she will need to bring a digital forensic expert.
* Usually, this is a trained officer called to join the scene investigation.
* If no trained officers are available, they can bring in external (civilian) digital forensic experts. Civilians would likely be under contract and have to act as police officers while on-scene.
* Civilians can usually do investigations and testify in court, but they cannot *make arrests*. Only "sworn" officers can make arrests.
8. The team goes on-scene for search and seizure.
* The digital forensic expert can collect devices and data (called "exhibits") based on what the warrant allows. They cannot take anything else.
* If investigators see something that is direct evidence, but not covered in the warrant, some countries have laws about how they can collect it.
9. Collected devices and data are taken into custody (Chain of Custody established), and they are taken back to the police station for storage in an evidence locker.
10. Eventually, the main investigator will have investigation questions relating to the digital exhibits. With these questions, the digital forensic expert starts her investigation using the devices and data that were collected.
11. Once the digital forensic expert finishes her report, it's sent to the main investigator. If the main investigator has more digital forensic (DF) questions, the digital forensic expert will continue analysis. If not, the case will be finished by the main investigator.
12. The case is sent to the prosecutors, who decide to prosecute or not. If they prosecute, then it goes to court. At court, the digital evidence can be cross-examined by an expert for the defense. The first DF expert may have to testify as an expert witness.
13. At that stage, the case is either finished or is sent back for more investigation.

Of course, there are a lot of variations on this procedure. Lots of things can happen during an investigation. The important thing to note is that digital evidence and exhibits don't just magically appear. A lot of things have to happen before we get to the digital investigation phase.