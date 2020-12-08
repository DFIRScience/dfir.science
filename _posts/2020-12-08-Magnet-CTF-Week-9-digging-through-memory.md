---
layout: single
title: "Magnet CTF Week 9 - Digging through memory"
date: '2020-12-08T01:00:00+09:00'
author: "Joshua I. James"
tags:
  - infosec
  - dfir
  - CTF
  - Magnet
modified_time: ""
---

Magnet Forensics is running a *weekly* forensic CTF. More information can be found on their [blog](https://www.magnetforensics.com/blog/magnet-weekly-ctf-challenge/). It is a fun way to practice, so let's get to it!

### CTF Posts

[Week 1](https://dfir.science/2020/10/Magnet-CTF-Week-1-Timestamps-of-doom.html) | [Week 2](https://dfir.science/2020/10/Magnet-CTF-Week-2-URLs-in-Pictures-in-Pictures.html) | [Week 3](https://dfir.science/2020/10/Magnet-CTF-Week-3-Failed-connections.html) | [Week 4](https://dfir.science/2020/11/Magnet-CTF-Week-4-GUIDSWAP-and-drop.html) | [Week 5](https://dfir.science/2020/11/Magnet-CTF-Week-5-HDFS.html) | [Week 6](https://dfir.science/2020/11/Magnet-CTF-Week-6-Riddle-ELF.html) | [Week 7](https://dfir.science/2020/11/Magnet-CTF-Week-7-Hadoop-Nodes.html) | [Week 8](https://dfir.science/2020/12/Magnet-CTF-Week-8-Persistence-in-plain-sight.html)

### Getting Started

New image for December! It can be found [here](https://drive.google.com/drive/folders/10fYCrNI46FT9l3LaJ9dj5gLxjlLtdnPo?usp=sharing). This is a memory image, and this week has multiple questions. Note: I may jump between Volatility 2.6 and 3 as I'm playing around.

> Q1: The user had a conversation with themselves about changing their password. What was the password they were contemplating changing too. Provide the answer as a text string.

The user may have used the word "password" in the conversation. If we do a string search including whitespace before and after " password ".

Use a basic hex editor and search for " password ". Offset ```0AF12A00``` starts a conversation that appears to be our suspect. Suspect refers to themselves as "Warren". The password considered is ```wow_this_is_an_uncrackable_password```. **BING!** Success.

> Q2: What is the md5 hash of the file which you recovered the password from?

I got the password from the raw data, so this question either means the hash of the memory dump, or the string was in a file. I don't see a recognizable file-header around the text. We will assume it is the memory dump.

```bash
$ hashdeep -cmd5 memdump-001.0.mem 
%%%% HASHDEEP-1.0
%%%% size,md5,filename
## Invoked from: ~
## $ hashdeep -cmd5 -j8 memdump-001.0.mem
## 
5368709120,224f93209cbea29e862890f30dfa762d,~/memdump-001.0.mem
```

Trying ```224f93209cbea29e862890f30dfa762d```.... **FAIL**. It was worth a try!

We can either try to carve out all files - using something like Photorec - and then search all the carved files or bring out the big guns and work with [Volatility](https://github.com/volatilityfoundation/volatility3). I bet there more questions later about memory structure, so we will switch to Volatility. See the Volatility [docs](https://volatility3.readthedocs.io/en/latest/).

First, let's get some image info:

```bash
$ ./vol3/vol.py -f memdump-001.0.mem windows.info
Volatility 3 Framework 2.0.0-beta.1
<!--snip-->
Variable	Value

Kernel Base	0xf80002a48000
DTB	0x187000
Symbols	file:///vol3/volatility/symbols/windows/ntkrnlmp.pdb/ECE191A20CFF4465AE46DF96C2263845-1.json.xz
primary	0 WindowsIntel32e
memory_layer	1 FileLayer
KdDebuggerDataBlock	0xf80002c2a120
NTBuildLab	7601.24384.amd64fre.win7sp1_ldr_
CSDVersion	1
KdVersionBlock	0xf80002c2a0e8
Major/Minor	15.7601
MachineType	34404
KeNumberProcessors	2
SystemTime	2020-04-20 23:23:26
NtSystemRoot	C:\Windows
NtProductType	NtProductWinNt
NtMajorVersion	6
NtMinorVersion	1
PE MajorOperatingSystemVersion	6
PE MinorOperatingSystemVersion	1
PE Machine	34404
PE TimeDateStamp	Thu Feb 21 03:36:29 2019
```

Now lets list processes (WINWORD looked the most interesting so I filtered for it using grep).

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 pslist | grep WINWORD
Volatility Foundation Volatility Framework 2.6
0xfffffa803177bb00 WINWORD.EXE            3180   2672     15      698      1      0 2020-04-20 23:17:06 UTC+0000 
```

PID 3180 looks interesting for writing documents. Let's check related files.

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 handles -p 3180 -t File | grep Warren
Volatility Foundation Volatility Framework 2.6
0xfffffa8032141e20   3180               0xb0           0x13019f File             \Device\HarddiskVolume1\Users\Warren\AppData\Local\Temp\~DF317615B8AE4AED39.TMP
0xfffffa80317e1c10   3180              0x59c           0x12019f File             \Device\HarddiskVolume1\Users\Warren\AppData\Local\Microsoft\Windows\Temporary Internet Files\counters.dat
0xfffffa8032be5ad0   3180              0x608           0x12019f File             \Device\HarddiskVolume1\Users\Warren\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.Word\~WRF{5223D233-5C82-4B8C-8259-5A82DF702F57}.tmp
0xfffffa8032d48cc0   3180              0x614           0x100020 File             \Device\HarddiskVolume1\Users\Warren\Documents
0xfffffa80324e0710   3180              0x930           0x100001 File             \Device\HarddiskVolume1\Users\Warren\AppData\Roaming\Microsoft\SystemCertificates\My
0xfffffa80326de810   3180              0x9c4           0x12019f File             \Device\HarddiskVolume1\Users\Warren\AppData\Roaming\Microsoft\Word\AutoRecovery save of Document1.asd
```

Here we see a temp file and an AutoRecovery file that may be interesting. I'll use the asd extension to try to dump the file from memory.

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 dumpfiles -D dump/ -r asd$ -i
Volatility Foundation Volatility Framework 2.6
DataSectionObject 0xfffffa80326de810   3180   \Device\HarddiskVolume1\Users\Warren\AppData\Roaming\Microsoft\Word\AutoRecovery save of Document1.asd
```

Checking strings in the file, it does include our suspicious text. Let's hash the asd file.

```bash
$ hashdeep -cmd5 file.3180.0xfffffa803316f710.dat 
%%%% HASHDEEP-1.0
%%%% size,md5,filename
## Invoked from: /dump
## $ hashdeep -cmd5 file.3180.0xfffffa803316f710.dat
## 
24576,af1c3038dca8c7387e47226b88ea6e23,/dump/file.3180.0xfffffa803316f710.dat
```

Trying ```af1c3038dca8c7387e47226b88ea6e23```, and **BING!** Success.

> Q3: What is the birth object ID for the file which contained the password?

This sounds like file-system meta-data. File-system meta-data makes me think about the MFT. Let's give it a go!

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 mftparser --output-file mft.txt
Volatility Foundation Volatility Framework 2.6
Outputting to: mft.txt
Scanning for MFT entries and building directory, this can take a while

$ cat mft.txt | grep -A 10 asd$
2020-04-20 23:22:36 UTC+0000 2020-04-20 23:22:36 UTC+0000   2020-04-20 23:22:36 UTC+0000   2020-04-20 23:22:36 UTC+0000   Users\Warren\AppData\Roaming\MICROS~1\Word\AutoRecovery save of Document1.asd
[snip]
$OBJECT_ID
Object ID: 40000000-0000-0000-0060-000000000000
Birth Volume ID: 005a0000-0000-0000-0056-000000000000
Birth Object ID: 31013058-7f31-01c8-6b08-210191061101
Birth Domain ID: f81101e8-3101-3d66-f800-000000000000
```

The birth object ID for the asd file is shown, and **BING!** Success.

> Q4: What is the name of the user and their unique identifier which you can attribute the creation of the file document to? Format: #### (Name)

For this, I assume the identifier is the Windows system identifier. I found [this post](https://www.aldeid.com/wiki/Volatility/Retrieve-password) which was handy for looking at user system info (related to passwords, but it works here too).

First, list the Registry hives.

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 hivelist
Volatility Foundation Volatility Framework 2.6
Virtual            Physical           Name
------------------ ------------------ ----
0xfffff8a005a95010 0x000000009743e010 \Device\HarddiskVolume1\Boot\BCD
0xfffff8a00000f010 0x00000000a979a010 [no name]
0xfffff8a000024010 0x00000000a97a5010 \REGISTRY\MACHINE\SYSTEM
0xfffff8a000059010 0x00000000a97da010 \REGISTRY\MACHINE\HARDWARE
0xfffff8a0002c9010 0x00000000a501b010 \SystemRoot\System32\Config\SOFTWARE
0xfffff8a000301010 0x00000000a47c2010 \SystemRoot\System32\Config\SAM
0xfffff8a0006dd410 0x0000000097538410 \SystemRoot\System32\Config\DEFAULT
0xfffff8a0008c5010 0x0000000091a74010 \SystemRoot\System32\Config\SECURITY
0xfffff8a000d91410 0x0000000087fc5410 \??\C:\Windows\ServiceProfiles\NetworkService\NTUSER.DAT
0xfffff8a000ff1010 0x0000000087717010 \??\C:\Windows\ServiceProfiles\LocalService\NTUSER.DAT
0xfffff8a0015f2010 0x0000000091ba8010 \??\C:\System Volume Information\Syscache.hve
0xfffff8a003ebd010 0x0000000022bd9010 \??\C:\Users\Warren\ntuser.dat
0xfffff8a003ec6010 0x00000000244dc010 \??\C:\Users\Warren\AppData\Local\Microsoft\Windows\UsrClass.dat
```

Next, use hashdump with the SYSTEM and SAM hives.

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 hashdump -y 0xfffff8a000024010 -s 0xfffff8a000301010
Volatility Foundation Volatility Framework 2.6
Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Warren:1000:aad3b435b51404eeaad3b435b51404ee:2aa81fb8c8cdfd8f420f7f94615036b0:::
```

We know the username is Warren, so the Windows account ID is 1000. Trying "1000 (Warren)", and **BING!** Success.

> Q5: What is the version of software used to create the file containing the password? Format ## (Whole version number, don't worry about decimals)

For this, I assume the version number will be somewhere in process memory. First, lets dump process memory for PID 3180.

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 procdump -D dump/ -p 3180
```

Next, use a hex editor (xxd) and search for the keyword "version". Note -A1 means "show 1 line after a match" in grep.

```bash
$ xxd executable.3180.exe | grep -A1 version
001d3440: 696e 776f 7264 2220 7665 7273 696f 6e3d  inword" version=
001d3450: 2231 352e 302e 302e 3022 2f3e 0d0a 093c  "15.0.0.0"/>...<
```

Version=15.0.0.0 but they has for the whole version number. Trying 15, and **BING!** Success.

> Q6: What is the virtual memory address offset where the password string is located in the memory image? Format: 0x########

This one was a bit tricky. I can get the physical offset of the keyword, but we are looking for the virtual offset. Lukily, Volatiltiy can do this conversion for us!

First, we get the physical offset using strings and grep. Strings -td will give the offset as a decimal, which is what Vol (2.6) accepts.

```bash
$ strings -a -td memdump-001.0.mem | grep this_is_an_ > keyword.txt
$ cat keyword.txt 
183577133 wow_this_is_an_uncrackable_password
```

The second line shows the output of our keyword. The entire keyword is there, so it looks good. Next, we feed Volatility the keyword list with the physical offset and keyword.

```bash
$ ./vol -f memdump-001.0.mem --profile=Win7SP1x64 strings -s keyword.txt 
Volatility Foundation Volatility Framework 2.6
183577133 [3180:02180a2d] wow_this_is_an_uncrackable_password
```

The result is the physical offset and the process ID and virtual offset in brackets. NICE! Trying ```0x02180a2d``` and **BING!** Success.

> Q7: What is the physical memory address offset where the password string is located in the memory image? Format: 0x#######

We had to answer this to answer the prior question. This time, however, we need to give the physical offset in hex.

```bash
$ strings -a -tx memdump-001.0.mem | grep this_is
af12a2d wow_this_is_an_uncrackable_password
```

Trying ```0xaf12a2d``` and **BING!** Success.

### Lessons learned

This week we got really practical with memory analysis, and in my case I used some features in Volatility that I'd never tried before. The whole process took several hours. The lesson for this week is that memory forensics, at least for older images, has improved a lot. I know I was using strings and grep often, but Volatility really made complicated memory analysis *easier*.