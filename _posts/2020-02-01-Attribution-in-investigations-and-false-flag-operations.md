---
layout: single
title: "Attribution in investigations and false flag operations"
date: '2020-02-01T10:29:57+09:00'
author: "Joshua I. James"
tags:
  - infosec
  - dfir
  - attribution
  - false flag
modified_time: ""
---

[Jake Williams](https://twitter.com/MalwareJake) gave a talk about false flag operations at [Black Hat Europe 2019](https://www.blackhat.com/eu-19/briefings/schedule/#conducting-a-successful-false-flag-cyber-operation-blame-it-on-china-17976). I've talked before about organizations being either lazy or political with cyberattack attribution. I've seen some of the methods that are used for attack attribution. The presentation is interesting because it goes into specific forensic artifacts that attackers have altered for ff operations. See the full video below.

{% include video id="W2vBu_Jui9A" provider="youtube" %}

An attacker can run false flags for many different reasons. It's not always about blaming another organization, but might just be about seeding doubt. Most importantly:

>False flags don't need to be perfect to be effective.

I looked at the IoCs shown in the video, and thought, "hey, I would follow that." Then Jake hit me with this line:

>It doesn't take much to throw an investigator off... when they're off, they're off for the long term.

In 2012 (South) Korean investigators would always immediately blame North Korea for all attacks. Yeah, sure, North Korea does do a lot in cyberspace, but I started asking people how they know it was the North. It often came down to malware code reuse.  The problem is that other governments also have access to the code. I thought false flag operations against Korea would be easy because of bias.

Sure enough, a few years later, Russia via [Olympic Destroyer](https://www.wired.com/story/untold-story-2018-olympics-destroyer-cyberattack/) reused code similar to North Korea's Lazarus group. You can read the full, interesting story in the book [Sandworm](https://amzn.to/37NaAC7).

The challenge for investigators, then, is how to reduce the time burden, or incorrect results, that false flag operations can produce. The video gives hints about potential FF IoCs through a massive dataset. But most investigators don't have access to such datasets. A FF discovery service would be useful, but bad actors could use that as well.

As investigators, we just need to avoid jumping to conclusions while being aware that some IoCs may be false flags. Attribution databases are a useful starting point, but, as we've seen, are not the 'ultimate answer.' For state-level attacks, I don't see how an investigator can be confident about attribution without additional intelligence-gathering. High-level intelligence is rarely shared with front-line criminal investigators. Form my experience, digital forensics is not used nearly enough for police intelligence, which - combined with other closed sources - could at least help keep front-line investigators from wasting time chasing FFs.

### Related reading

Several documents, especially from wikileaks, were discussed. If you've not seen them, it is worth taking a look.

* Vault 7 - (https://wikileaks.org/vault7/)
* CIA Hacking Tools Leaked Umbrage - (https://wikileaks.org/ciav7p1/index.html)