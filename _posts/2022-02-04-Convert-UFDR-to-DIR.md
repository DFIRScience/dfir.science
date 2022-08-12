---
layout: single
title: "Convert UFDR to DIR"
permalink: /:year/:month/:title
date: '2022-02-04T17:30:08-06:00'
tags:
  - dfir
  - cellebrite
  - python
header:
  image: /assets/images/posts/headers/dsg-text.jpg
  caption: "Photo by [Clark Tibbs](https://unsplash.com/@clarktibbs?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/text?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)"
modified_time: ""
---
 
In a [prior post](https://dfir.science/2022/02/How-to-extract-files-from-Cellebrite-Reader-UFDR-for-ALEAPPiLEAPP) we tested parsing a Cellebrite Reader UFDR file directly with ALEAPP. Although ALEAPP could process the file if we renamed it with a .zip extension, it had a bad performance. This is because most ALEAPP artifacts are somewhat directory-specific. UFDR files contain original data from a device but categorize all files. The original path structure is lost, and ALEAPP cannot match the expected file.

Luckily, UDFR kept a large log of original file information and moved them (the Local Path). We can parse ```report.xml``` from the root of the archive to get both items. Then use that information to recreate the original directory structure, and extract the local file data back into the original location.

You can find the Python script to do that here: [https://github.com/DFIRScience/UFDR2DIR](https://github.com/DFIRScience/UFDR2DIR)

Just point ```UDFR2DIR.py``` at a ufdr file, and it will create the original directory structure. Then you can process that directory with tools like ALEAPP, iLEAPP, Autopsy, etc.

```
:~/Documents/Projects/UFDR2DIR$ python3 ufdr2dir.py ~/Desktop/Cellebrite_Reader/Android_12_Cellebrite_Reader.ufdr
UFDR2DIR v0.1.1
[INFO] 2022-33-04T17:33:09 Extracting report.xml...
[INFO] 2022-33-04T17:33:10 Creating original directory structure...
|████████████████████████████████████████| 18821135 in 12:03.4 (26019.34/s)
```

Here are the ALEAPP results before reconstruction:
![ALEAPP with UFDR before reonstruction](/assets/images/posts/aleapp-ufdr-before.png)

Here are the ALEAPP results after reconstruction:
![ALEAPP with UFDR after reonstruction](/assets/images/posts/aleapp-ufdr-after.png)

## Note

UFDR can contain some deleted file data. If it does not have a path, the script does not extract it (yet). We also do not try to reconstruct
file and folder timestamps.

If this is something you would find useful, [let me know](https://twitter.com/dfirscience).