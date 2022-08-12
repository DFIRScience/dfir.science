---
layout: single
title: "A more efficient NSRL for digital forensics"
permalink: /:year/:month/:title
date: '2022-02-06T09:33:59-06:00'
tags:
  - infosec
  - dfir
header:
  image: /assets/images/posts/headers/cryptonet.jpg
  caption: "Photo by [Uriel SC](https://unsplash.com/@urielsc26?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/fast?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)"
modified_time: ""
---
 
A few days ago, [Hexacorn](https://twitter.com/Hexacorn) released a [blog post](https://www.hexacorn.com/blog/2022/02/04/analysing-nsrl-data-set-for-fun-and-because-curious/) taking a look at the NSRL RDS hash set. I'm a total fan of hash sets.
I think they are *one of the easiest ways to capture and reuse institutional knowledge*. As such, I use RDS a lot.

Hexacorn's post made me realize that 1. I'd never really questioned the RDS before, and 2. I was wasting valuable CPU cycles!
Both of those end today! The goal is to explore a bit deeper and hopefully create a more efficient NSRL for specific #DFIR use cases.

## Use Case

My primary use case for the NSRL and similar is to filter known-good from particular views in [Autopsy](https://www.autopsy.com/) and similar.
As such, this statement jumped out at me:

> ...what we believed to be just large file hashset is actually a mix of files hashes and hashes of sections of executable files.
> <cite><a href="https://www.hexacorn.com/blog/2022/02/04/analysing-nsrl-data-set-for-fun-and-because-curious/">Hexacorn</a></cite>

Sections of executable files might be relevant for binary/malware analysis, but I rarely use them. What's more, the filtering
tools that I use don't do partial hashing. It's the whole file or nothing. So this set of partials is a complete waste and will be
our main target.

Hexacorn seems most interested in executable file types. I'm interested in any whole-file, known-good. I don't want to see system files.

## NSRL

I'm using [NSRL](https://www.nist.gov/itl/ssd/software-quality-group/national-software-reference-library-nsrl/nsrl-download/current-rds)
*Modern RDS (minimal)* v2.75. Note that v3 uses SQLite instead of a flat-file. We will have to look into that later.

### Analysis

Number of hashes

```shell
$ cat NSRLFile.txt | wc -l
41850362
```

Number of operating systems:

```shell
$ cat NSRLOS.txt | wc -l
1366
```

Number of Windows OS versions:

```shell
$ cat NSRLOS.txt | grep -i windows | wc -l
452
```

Number of (likely) Java embedded .class files:

```shell
$ cat NSRLFile.txt | grep -i "\.class" | wc -l
2684902
```

Quick search for "text":

```shell
$ cat NSRLFile.txt | grep -i text
"09CFCDFC2518CD2CCD485886FCEB3482BD3B70B9","D28C508D50A618C6D2C2427C37D20378","F4D7BC42",".rela.text._ZNSt15basic_stringbufIcSt11char_traitsIcEN8MathLink14MLStdAllocatorIcEEED2Ev",144,220911,"362",""
"09CFE07D1F0B3708CB2B85DFE4383D230EE88566","1B90C2C60F67F6EBDD274D15535B31FF","6644FF02",".text",3072,215747,"362",""
"09CFE897BA7ACCED588B1578277AEA3DEC78F43C","BC33A1DB9D809F66DFD6711913EF9410","A76E8A16","__TEXT__text",8868661,188984,"362",""
"09CFE8DF7F5F045F90634FD3FBB13EB0A0DCD7BD","56684E4BECD0008ED0B6A07DA2AC1C93","AF01A7EF","krb5_copy_context.txt",552,17398,"362",""
"09CFEEF7EEB4715FFD49DC316AC0824E055F5F73","13802B6D11AE8651A87609CE698390A0","569CF14F",".text",102400,17379,"362",""
"09CFF16AE1AE84ADD2F19D64AA2C12239D920D3F","20E1FA0A206B2E7E5E5280FE7A06F531","10A1766A","buildingtextures_yellowcorrigated01a.vtf",699256,189286,"362",""
"09CFF8FFEBAC0E34C8C3F9CEAF6259D324CF61B2","3F724C1809E65ED9A1A519400B1BB02B","3B27605C",".text",27319,181156,"362",""
"09CFFA803F6CCAF7BD0CF0A53966888F0C1D8115","F7B119BC72B0A6E3C86231071A8D0C9D","6B4D23AD",".text",14997,181156,"362",""
```

Quick search for "1":

```shell
$ cat NSRLFile.txt | grep -i "\"1\"" | wc -l
242521
```

Entries that start with ".":

```shell
$ cat NSRLFile.txt | grep -P "\"\..*?\"" | wc -l
5765736
```

Entries that start with "__":

```shell
$ cat NSRLFile.txt | grep -P "\"__.*?\"" | wc -l
1108010
```

Check top system codes:

```shell
cat NSRLFile.txt | awk -F"," '{print $7}' | sort | uniq -c | sort | head
```

We also found system code 362 ```"362","TBD","none","1006"```, which a lot of entries use. Looks like to be determined... meaning
they don't know the OS? Entries look like Microsoft stuff, plus some of our code segments:

```shell
"55.NTDSAPI.dll""362"
"CERTIFICATE""362"
"714""362"
"Nfc.h""362"
"Tile_-28_-28.foliage""362"
"package$.class""362"
"bare2.ms""362"
"generic_xts.po""362"
"Microsoft-Windows-Casting-Platform-WOW64-avcore-Package~31bf3856ad364e35~amd64~ms-MY~10.0.14393.0.mum""362"
"om5651.arc""362"
"3507.mfc140u.dll""362"
"gedit-search.page""362"
```

A LOT of entries are listed under 362. So many that we should filter them, but also save them into an "other" category.

Files that are *not* 362:

```shell
$ cat NSRLFile.txt | grep -vi 362 | wc -l
1
```

Ah, well, that's not good. All entries have a, OS category of 362. Meaning OS categories, for now, are totally worthless.

### Observations

Based on this exploration, there are a few things we might want to do.

1. Entries that start with ```__``` and do not have an extension are probably section hashes. Exclude
2. Entries that start with ```.``` are also probably section hashes, though for Linux and MacOS this may not be true. Exclude
3. Entries with ```.text```, ```text``` and ```1``` have many entries, but it's unclear why. Exclude?
4. ~~Split the sets by general OS instead of all-in-one. Select set based on needs.~~ No OS cat info avail.
5. Filter very old OS
6. .class files - most likely embedded in java. Exclude?

## Testing speed assumptions

All of this assumes that reducing the hash set has some reduction in CPU cycles / time. Let's test that.

Take half of NSRLFile.txt.

```shell
$ head -n 20925181 NSRLFile.txt > HalfNSRLFile.txt
$ wc -l HalfNSRLFile.txt 
20925181 HalfNSRLFile.txt
$ wc -l NSRLFile.txt 
41850362 NSRLFile.txt
```

Create an hfind index for both. Note we're using the NSRL-SHA1. Matching with MD5 is faster but too easy to get collisions.
Plus, by filtering NSRL we can be more efficient, faster *and* more accurate.

```shell
$ hfind -i nsrl-sha1 NSRLFile.txt 
Index created
$ hfind -i nsrl-sha1 HalfNSRLFile.txt 
Index created
```

Create some SHA1 hashes from a test dataset.

```shell
$ sha1deep -r ~/Desktop/Cellebrite_Reader/ > testHashes.sha1
$ wc -l testHashes.sha1 
109950 testHashes.sha1
$ cat testHashes.sha1 | awk '{print $1}' > hashes.sha1
```

Measure time of full DB lookup.

```shell
$ time hfind -f hashes.sha1 NSRLFile.txt >/dev/null

real	0m37.942s
user	0m0.580s
sys	0m3.391s
```

Clear cache and measure time of half DB lookup.

```shell
$ sudo sysctl vm.drop_caches=3
$ time hfind -f hashes.sha1 HalfNSRLFile.txt >/dev/null

real	0m9.707s
user	0m0.319s
sys	0m1.306s
```

Unexpectedly, half the NSRL hashes took approximately 25% of the (real) time of the whole set, and 38% system time. This was only for 100k file hashes. On a normal case, we will see some big improvements by reducing the set as much as possible. This assumes you were dumping the full NSRL in your tools (like I was!).

## Building a filter

First, we get the Windows codes.

```shell
cat NSRLOS.txt | grep -i Windows | grep -v "X Windows" | awk -F"," '{print $1}' > temp.txt
```

Most OSs filtered out easily. Unix/Linux gave some trouble, of course. At this stage, we also removed some of the much older OSs.

```shell
cat NSRLOS.txt | egrep -vi "(windows|android|ios|mac|msdos|ms dos|amstrad|netware|nextstep|aix|compaq|dos|dr dos|amiga|os x|at&t|apple)" | awk -F"," '{print $1}' > temp.txt
```

This gives us the codes for Windows, Mac, Android, iOS, Unix/Linux, and an other category of 362. Note, everything is 362 so filtering by OS isn't useful at this time.

### Filename filter

Filenames are pretty much our only indicator of a segment or not. In that case, we can search based on starting with __ or . 

Not ideal, but unless we parse out and somehow rationally filter on product, this is as good as it gets.

```python
if FN.startswith("__") or FN.startswith("."): continue
```

This is easy to expand with regular expressions if other meaningful filename patterns are found.

## Filtering end result

As of this writing, we're basically
just removing files that start with __ and period. The filter as-is can be replicated much faster in bash:

```shell
$ cat NSRLFile.txt | grep -v "\"__" | grep -v "\"\." > ENSRL.txt
$ wc -l ENSRL.txt 
34976616 ENSRL.txt
```

This is about 83% of the original hash values. Even with that we can expect some processing-time improvements with a low likelyhood of missing many filtering opportunities.

### A filtering tool and Efficient-NSRL

The ENSRL can be found here: [https://github.com/DFIRScience/Efficient-NSRL](https://github.com/DFIRScience/Efficient-NSRL). 

Future work will try to fine-tune based on the file name and might try to use NSRLProd.txt. It would be nasty, but that seems like the only useful categorization data.

Hit me up on [Twitter](https://twitter.com/dfirscience) if you have any filtering recommendations. Pull requests also welcome.