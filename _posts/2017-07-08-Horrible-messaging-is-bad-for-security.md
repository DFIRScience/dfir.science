---
layout: single
title: "Horrible messaging is bad for national security"
date: '2017-07-08T12:51:47+09:00'

tags:
- infosec
- public awareness
- emergency messaging
- emergency response
- incident response
- SMS spam
- SMS alerts
- Don't do this
- National Security
modified_time: '2017-07-08T12:51:47+09:00'
---

For over a year, anyone with a mobile phone in Korea has had to put up with spam text messages from Korea's Ministry of Public Safety and Security (국민안전처). I thought it was wise to have such an emergency system considering that I live about 30km from the DMZ (boarder with the North), unfortunately this ministry found a way to make such an emergency system less effective.

## Background Insanity
*Note:* I am greatly summarizing complex Korean modern history. It's worth looking up.

Before we get into why the emergency messages are so ineffective, let's take a look at the ministry itself. The Ministry of Public Safety and Security was created in 2014 after the [Sewol Disaster](https://en.wikipedia.org/wiki/Sinking_of_MV_Sewol). Both the cause and the response to the disaster was beyond idiotic, but surprisingly little has improved since then. While the ferry was sinking, the heads of the Korea Coast Guards 1) were told that everyone was saved 2) asked the survivors to be brought to them for a photo op. Bad intelligence + bad leadership was a hallmark of every government organization involved. Then-President (impeached) [Park Geun-hye](https://en.wikipedia.org/wiki/Park_Geun-hye) was lax and indecisive about in her response.

About a month after the disaster, Park decided to dissolve the Coast Guards, and create the Ministry for Public Safety and Security. Who needs training when you can just change the name? Current Coast Guards were given the option to join the Ministry or the Police. Basically, the Ministry was created to help centralize Park's power and promote those loyal to her. If you worked for the Ministry you were working for ~~Woo Byung Woo~~ Park Geun-hye ~~Choi Soon-sil~~. If you worked for Police, you were working for Woo Byung Woo ~~Park Geun-hye~~ ~~Choi Soon-sil~~, but probably didn't know it. So basically, all the people that couldn't respond to a real emergency were given a Ministry.

### Maybe they actually do stuff?
One of the best ways to see if a Korean organization is effective is to look at their English websites. The English sites are not usually maintained, so whatever is there when it is created is the essence of what the organization is. If we look at the reason for [establishment](https://www.mpss.go.kr/en/mpss/establish/) they say:

> Ministry of Public Safety and Security is an organization for safety of People and disaster management that handles all sorts of disasters and safety problems. It was established in an effort to create a prompt, comprehensive system, to cope with disasters and safety problems by building a systematic disasters and safety management system.

Did you get that? The ministry was created to handle "all sorts of disasters." What's a disaster? It doesn't matter. Does anyone else do this? Yes. Does it matter that this is overlapping with other agencies? Nope. The rest of the website is equally as lacking in substance, except the organizational chart. Here we see a consolidation of power, and more bosses for already overly bureaucratic organizations. I feel safer already.

Looking through the Korean-language version, there is a lot more information. However, I don't see much that didn't already exist before this Ministry.

## Spam Emergency SMS
You're probably thinking... weren't we talking about emergency SMS spam? Yes!

![Spam emergency texts from the Korean Ministry of Public Safety and Security (국민안전처)](https://DFIR.Science/assets/images/posts/2017WarningMsg.jpg "Non-emergency emergency messaging")

The thing about Korean Government organizations is that **showing** that they are doing something is almost as good as doing something (it's not just Korea). Something easy to do is send SMS messages on the government emergency channel. Every phone receives these messages, and it may buzz or beep in a special way so you know it's urgent. Example messages in the picture above.

The problem is that the ministry uses the emergency channel 1) too much 2) for non-emergency news 3) with really poor messages. In the example above, the last message says:

> Heavy rainfall, evacuate areas that have frequent landslides and flooding, be careful for your safety by refraining from going outdoors.

With a quick read we can understand "be careful." Not exactly an emergency message. If we think that this is actually an emergency message then I have a LOT more questions:

* Heavy rainfall where? It's not raining where I am.
* Evacuate - to where?
* Areas that have frequent landslides and flooding? Is that my area? What area are you talking about?
* Be careful - How?
* Don't go outdoors - you just told me to evacuate. Do I stay or do I go?

By looking at the news I can see that the southern part of Korea is experiencing some flooding. But with this "emergency message" I don't have enough information to make a decision and act immediately.

The emergency messages I normally receive: it's hot, it's cold, it's raining. None of them required my behavior to change in any way. It turns out that in summer it is hot almost daily.

## The Problem and Some Solutions
First, the scope of emergency messaging needs to be reduced. For example we could split messaging into *real emergencies* and *general warnings*. Opt everyone into general warnings by default, but give an easy way to opt out via SMS. Use the emergency channel for real emergency information only (i.e. evacuate to Busan now - don't take personal items). Warning messages would be sent over normal SMS. By dividing messages into "Emergencies" and "Warnings" the number of texts that are emergencies would also be reduced, and people would be less likely to ignore emergency messages.

Second, poor messaging. Emergency information should:

1. Be complete
2. Be specific
3. Be relevant
4. Be actionable

Bad example:

> Do something unless you don't need to, then don't.

Good example:

> People in this location must do this thing by this time, emergency services contacted this way.

# Conclusion
Korea's Ministry for Public Safety and Security was created for bad reasons. However, they do have a chance to actually improve and make Korea safer. Unfortunately, with every non-emergency, emergency text they send, they are showing everyone that they're are incapable of thinking about appropriate incident response, and that they are PR spammers. I'm not sure which one is worse (kidding - incident response would be a disaster in S. Korea).
