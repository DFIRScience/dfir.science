---
layout: posts
title: 'A comment on Applebys reaction to the Paradise Papers'
date: '2017-11-06T19:50:48+09:00'
author: Joshua
tags:
- infosec
- hacking
- commentary
modified_time: '2017-11-06T19:50:48+09:00'
---

Today the [International Consortium of Investigative Journalists](https://www.icij.org/) (ICIJ) released "The Paradise Papers."  These look to be a massive collection of documents related to offshore bank accounts. According to the ICIJ's disclaimer:

> There are legitimate uses for offshore companies and trusts. We do not intend to suggest or imply that any people, companies or other entities included in the ICIJ Offshore Leaks Database have broken the law or otherwise acted improperly. Many people and entities have the same or similar names. We suggest you confirm the identities of any individuals or entities located in the database based on addresses or other identifiable information.

Yes, people do have legitimate uses for making offshore bank accounts. Like tax evasion. Heck, even [patriotic North Koreans](https://news.kcij.org/31) love to store their cash outside the country. It's too soon to know how much of an impact this will have, and to whom. I'm more interested in [Appleby's reaction](https://www.applebyglobal.com/news/news-2017/media-coverage-of-the-offshore-sector.aspx) to the leak.

I'd never heard of Applebys before. Not surprising since they describe their clients as "high net worth individuals." They claim to be "Intelligent and insightful offshore legal advice and services." If you look at their job postings they are mostly in... tax havens.

<figure class="full">
  <img src="/assets/images/posts/appleby.jpg">
</figure>

Appleby's seemingly panicked response (pictured above) is interesting. They claim that they've done nothing unlawful even though the media does not claim they did anything unlawful. Preempting the question, I guess. They then mention unrelated allegations (about clients) "*with a clear political agenda and movement against offshore*." I'm supposed to believe that reporters from [all over the world](https://www.icij.org/paradise-papers-media-partners/) are organizing under a single political agenda? A little far-fetched, but possible. Even if I accepted possible political motive, which I don't, I don't see how the agenda is "clear."

So, weird first paragraph, but what I'm most interested in is the second paragraph.

> We wish to reiterate that our firm was not the subject of a leak but of a serious criminal act.

Interesting. How do you know that this was a criminal act? How do you know that it was *not* a leak?

> This was an illegal computer hack.

Great. So you know what system was hacked, how the attack took place, what documents were stolen and have secured your systems so something like this can never happen again?

> Our systems were accessed by an intruder who deployed  the tactics of a professional hacker and covered his/her tracks to the extent that a forensic investigation by a leading international Cyber & Threats team concluded that there was no definitive evidence that any data had left our systems.

 First off, bad sentence. Second, what is that double space between "deployed" and "the tactics"? Do they know that someone deployed specific software or tools, but decided to generalize? Do they know that someone *intruded*? Under which legislation are we defining intrusion?

 The golden nugget is the last terrible part of the terrible sentence. A leading forensic investigation company already investigated and found nothing... So not only is everything you just said pure assumption, but you assume that they are professional hackers *because you found no evidence*. **Trojan defense, ladies and gentlemen.**<sup>1</sup>

 > This was not the work of anybody who works at Appleby.

 No evidence of intrusion and ex-filtration kinda points the other way.

 > ... It is plain that the source of documents is not confined to Appleby.

 So, now the documents are legitimate, but not only from Appleby. What were you trying to do with this paragraph?

#### To summarize the Appleby argument
 > There was no internal leak.
 > We were hacked.
 > There is no evidence of hacking.
 > The hacker must have been a pro.

What?

## In conclusion

This is a group of international lawyers. Their argument is that they were hacked, lost 13.4 million documents, **and can't detect the loss**. What's worse? An insider leaking documents, or not being able to protect against, or even detect, an external loss of millions of sensitive documents?

I understand they don't want to be responsible for disclosure because that would make them legally responsible. If they were hacked, they might get insurance. However, the argument they put forth is both poorly planned and poorly executed. They make claims that are contradictoray, and are obviosly trying to have a cover story ready. Weird response.

I don't know or particularly care about this company. If they were actually victims, I hope that justice is served. This response, however, discredits them further. Anyone suffering from an internal leak that wants to pin it on super-hackers, take note about what not to do.


<sup>1</sup> Or however you prefer to identify.
