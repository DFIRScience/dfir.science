---
layout: posts
title: "[How To] Fuzzy Hashing with SSDEEP (similarity matching)"
date: '2017-07-18T19:27:49+09:00'
author: Joshua
tags:
- infosec
- dfir
- ssdeep
- fuzzy hashing
modified_time: '2017-07-18T19:27:49+09:00'
---

[SSDEEP](http://ssdeep.sourceforge.net/) is a fuzzy hashing tool written by Jesse Kornblum. There is [quite a bit of work](http://www.sciencedirect.com/search?qs=ssdeep&authors=&pub=Digital%20Investigation&volume=&issue=&page=&origin=journal&zone=qSearch&publicationTitles=273059&withinJournalBook=true) about similarity hashing and comparisons with other methods. The mainstream tools for digital forensics, however, appear to be ssdeep and [sdhash](http://roussev.net/sdhash/sdhash.html). For example, NIST created [hash sets](https://www.nist.gov/itl/ssd/cs/non-rds-hash-sets) using both tools. I wrote a [post](https://DFIR.Science/2012/09/similarity-comparison-with-sdhash-fuzzy.html) about sdhash in 2012 if you want to know a little more about how it works.

Let's get to it!

## ssdeep
SSDEEP creates a hash value that attempts to detect the level of similarity between two files at the *binary* level. This is different from a cryptographic hash (like SHA1) because a cryptographic hash can check *exact* matches (or non-matches).

A cryptographic hash is useful if we want to ask "Is file 1 exactly like file 2?" A fuzzy hash / similarity hash is useful if we want to ask "Does any part of file 1 exist in file 2?"

### An example
Imagine the a file with the following text:

> One morning, when Gregor Samsa woke from troubled dreams, he found himself transformed in his bed into a horrible vermin.

> He lay on his armour-like back, and if he lifted his head a little he could see his brown belly, slightly domed and divided by arches into stiff sections. The bedding was hardly able to cover it and seemed ready to slide off any moment.

> His many legs, pitifully thin compared with the size of the rest of him, waved about helplessly as he looked. "What's happened to me? " he thought. It wasn't a dream. His room, a proper human room although a little too small, lay peacefully between its four familiar walls.

> A collection of textile samples lay spread out on the table - Samsa was a traveling salesman - and above it there hung a picture that he had recently cut out of an illustrated magazine and housed in a nice, gilded frame. It showed a lady fitted out with a fur hat and fur boa who sat upright, raising a heavy fur muff that covered the whole of her lower arm towards the viewer. Gregor then turned to look out the window at the dull weather.

If we use a cryptographic hash, we may get the following hash value (SHA1):

```bash
joshua@Zeus ~/ $ sha1sum test.txt
2222825996bb74f3824e75e2dd44b0095d3b300a  test.txt
```

With ssdeep we get the following fuzzy hash value:

```bash
joshua@Zeus ~/ $ ssdeep -s test.txt
ssdeep,1.1--blocksize:hash:hash,filename
24:Ol9rFBzwjx5ZKvBF+bi8RuM4Pp6rG5Yg+q8wIXhMC:qrFBzKx5s8sM4grq8wIXht,"~/test.txt"
```

So far we can see that ssdeep hashes are much larger that MD5 hashes. That means storing a large number of fuzzy hashes will take a lot more space, so we need to consider when fuzzy hashing is most useful for our investigations.

I'm going to output our fuzzy hash into a "database" that I can use to match later. You can name the database anything you want. I'm going to use "fuzzy.db" for now.

```bash
joshua@Zeus ~/ $ ssdeep -s test.txt > fuzzy.db
```

Now the file fuzzy.db contains the fuzzy hash created from test.txt. Now imagine we remove the words **pitifully thin compared with the size of the rest of him** from the original file. What happens to our hashes?

```bash
joshua@Zeus ~/ $ sha1sum test.txt
25ce1f22b6391d552591f1c4bec70047998ab344  test.txt
joshua@Zeus ~/ $ ssdeep -s test.txt
ssdeep,1.1--blocksize:hash:hash,filename
24:Ol9rFBzwjx5ZKvBBi8RuM4Pp6rG5Yg+q8wIXhMC:qrFBzKx5L8sM4grq8wIXht,"~/test.txt"
```

If we look at the SHA1 hash, it is completely different. This is exactly what it **should** do. If a single bit changes, the resulting cryptographic hash should change. But what about the fuzzy hash? In the main string, we see some similarities, which a change at **BBi8RuM4Pp6rG5Yg**. OK, so both hashes are different, so what?

When we compare the original SHA1 hash value to the new value, we wont see both files as the "same", even though text.txt is now just a modified version of the original.

For ssdeep, let's use the saved hash value from before, and compare it to the current version of the the file.

```bash
joshua@Zeus ~/ $ ssdeep -s -m fuzzy.db test.txt
~/test.txt matches fuzzy.db:~/test.txt (97)
```

Here we see 97, or how similar the two files are. 97 means they are almost the same file. If I remove all of the last paragraph in the text file, I get a score of 72. If I remove the first AND last paragraphs, I get a score of 63.

## File Formats Matter
When working with fuzzy hashes, file formats matter a lot. Compressed file types are not going to work as well as non-compressed. Let's take a look at MS Word document types; docx and doc. Two files, both contain "This is a test."

```bash
joshua@Zeus ~/ $ ssdeep -s test*
ssdeep,1.1--blocksize:hash:hash,filename
48:9RVyHU/bLrzKkAvcvnU6zjzzNszIpbyzrd:9TyU/bvzK0nUWjzzNszIpm,"~/test.doc"
96:XVgub8YVvnQXcK+Tqq66aKx7vlqH5Zm03s8BL83ZsVlRJ+:Xuub83HKR6OxIjm03s8m32l/+,"~/test.docx"
```

We can already tell the two files are probably not similar, which is correct because the underlying file format *data structure* is completely different. Similarities are some of the application meta-data and the text. Just for fun, let's see if the files are similar to each other.

```bash
joshua@Zeus ~/ $ ssdeep -s test* > fuzzy.db
joshua@Zeus ~/ $ ssdeep -s -a -m fuzzy.db test.*
~/test.doc matches fuzzy.db:~/test.doc (100)
~/test.doc matches fuzzy.db:~/test.docx (0)
~/test.docx matches fuzzy.db:~/test.doc (0)
~/test.docx matches fuzzy.db:~/test.docx (100)
```

That would be a nope. The files are similar to themselves, but not to the other format.

Next, let's change the contents of each file and see if it is similar to itself. We add "Hello." before "This is a test."

```bash
joshua@Zeus ~/ $ ssdeep -s -a -m fuzzy.db test.*
~/test.doc matches fuzzy.db:~/test.doc (83)
~/test.doc matches fuzzy.db:~/test.docx (0)
~/test.docx matches fuzzy.db:~/test.doc (0)
~/test.docx matches fuzzy.db:~/test.docx (52)
```

What's going on here? Doc and Docx are still not similar to each other. But both the new version of the doc and docx file are similar to the prior version. Notice that the doc is "more similar" that the docx. The reason is because docx is a type of compressed file format. Think of docx like a zip container. This means that a small modification has a larger impact on the final binary output when compressed.

### Bits!
The original docx was 4,080 bytes, and the modified docx was 4,085 bytes. Only a 5 byte difference resulted in a difference of 48.

The original doc was 9,216 bytes, and the modified doc was 9,216 bytes. I actually wasn't expecting that, and will look into why it's the same size. The *structure* did change, however. That's why the similarity score is 83.

### More data
Let's go back to our original text, which is much longer, and remove the same text as last time. With more text, the application meta-data (timestamps) that change should have less of an effect on our matching.

```bash
joshua@Zeus ~/ $ ssdeep -s test* > fuzzy.db
joshua@Zeus ~/ $ ssdeep -s -a -m fuzzy.db test.*
~/test.doc matches fuzzy.db:~/test.doc (83)
~/test.doc matches fuzzy.db:~/test.docx (0)
~/test.docx matches fuzzy.db:~/test.doc (0)
~/test.docx matches fuzzy.db:~/test.docx (0)
```

Here we can see that for the compressed file type, more data is worse for similarity matching. This is likely in the way that the compression algorithm works. Our change is about mid-way in the document, but the last paragraph is the longest (most data). After our modification, the compression algorithm will compress the data with a different pattern than before.

For the doc file, we see that more data is *better*. We were able to remove more data from the original, but still managed a similarity score of 83.

## Testing with Images
I made a video about ssdeep and testing different image formats. Have a look below:

{% include video id="xY4YggSTnD8" provider="youtube" %}

## Conclusions
Hopefully this gave you a better idea of fuzzy hashing, and what it can be used for. For certain situation it is extremely useful, but you definitely need to know what data-types you are working with. Uncompressed data will likely give better results.
