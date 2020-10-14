---
layout: single
title: "Get top tweeting usernames based on hashtag"
date: '2020-10-14T18:10:35+09:00'
author: "Joshua I. James"
tags:
  - infosec
  - dfir
  - twitter
  - analysis
  - OSINT
modified_time: ""
---

I was thinking about the [Magnet Weekly Forensics CTF Challenge](https://www.magnetforensics.com/blog/magnet-weekly-ctf-challenge/). There are a few ways to get points: answering the CTF question, trivia, and posting on social media.

On Twitter, you could click on the [#MagnetWeeklyCTF](https://twitter.com/search?q=%23MagnetWeeklyCTF) hashtag and *manually* count how many times someone has posted.

Manually? No, thank you!

To avoid manual labor, I wrote the following Python script. If you are new to Python, check out our [Python for Beginners](https://dfir.science/python/) video series.

<script src="https://gist.github.com/jijames/733f483abd166312b14a16300400f580.js"></script>

The script is pretty straightforward. I use the tweepy Python library to connect to the Twitter API, and request all tweets with the #MagnetWeeklyCTF hashtag. Tweepy allows you to specify the date. And we include ```-filter:retweets``` so we only see original posts.

Once we get all that data, we can loop over each item and pull out the author's screen name. We then get a list that contains a value one or more times.

The most challenging bit is to count the number of screen_name occurrences in the list. In Linux, we would typically do something like:

```bash
$ cat list.txt | sort | uniq -c
```

This command takes all the items from "list.txt" file, sorts them alphabetically, and makes sure each occurrence only appears once. The -c adds the occurrence count to the output.

But we are writing in Python, so we turn to a library. In the collections library, we find "Counter." Counter does something very similar to ```sort | uniq -c```.

Since we want to see the screen_name and number of occurrences, the base output of Counter is good enough. When we run it, we get the following output:

```bash
$ python3 tweetCount.py 
Counter({'amick_trey': 12, 'CiofecaForensic': 5, 'dwmetz': 4, 'DFIRScience': 4, 'petermstewart': 3, 'MagnetForensics': 3, 'Uncle_Petey2': 2, 'svch0st': 2, '4n6_ch': 2, 'B1N2H3X': 2, 'ollerery': 2, 'KorstiaanS': 2, 'KevinPagano3': 2, 'jdr4class': 1, 'otter404': 1, 'NihithNihi': 1, 'jsaspo': 1, 'rootk1d_': 1, 'kevroded': 1, 'Rolf_Govers': 1, 'LVRamirez': 1, 'DeltaEcho8426': 1, 'Abhiman29042247': 1, 'mrvoltog': 1, 'Forensicator4': 1, 'Azotium': 1, 'MrEerie': 1})
```

As expected, amick_trey talked about the CTF A LOT. @DFIRScience is currently 4th in talky-ness.

### What's the point?

The script is super basic—no error checking. No optimizations. It took about 10 minutes to write.

This use case is a bit stupid - who is talking about a CTF on Twitter the most.

But this is an excellent example of how a simple script can give you some great insight into who is *influencing* a conversation. If this hashtag were related to terrorism, I would be pretty interested in who the top poster was. Alternatively, I may be interested in who the bottom-most tweeters are.

There is some control over date searched, and you don't need to mess with Twitter's weird sorting. You can also dump the results into another tool for additional searches, monitoring, etc.

Thanks to this 10-minute script, I can track suspects. Or - at least - stalk some forensicators.
