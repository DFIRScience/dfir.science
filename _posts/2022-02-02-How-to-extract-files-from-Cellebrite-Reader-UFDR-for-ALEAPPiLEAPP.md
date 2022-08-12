---
layout: single
title: "How to extract files from Cellebrite Reader UFDR for ALEAPP or iLEAPP"
permalink: /:year/:month/:title
date: '2022-02-02T17:07:54-06:00'
tags:
  - dfir
  - ALEAPP
header:
  image: /assets/images/posts/headers/android.jpg
  caption: "Photo by [Rami Al-zayat](https://unsplash.com/@rami_alzayat?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/fast?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)"
modified_time: ""
---
 
Sometimes you are presented with odd file types from forensic tools. These odd file types are often related to forensic disk images or other containers.

One such odd file type is a Cellebrite Reader file (UFDR). Today let's look at how to extract data from a Cellebrite Rader ufdr and analyze it with ALEAPP or iLEAPP.

Note Cellebrite also has UFD and UFDX file types. Cellebrite UFD files are text files that contain acquisition meta-data. Cellebrite [UFDX](https://cellebrite.com/en/learn-more-about-ufd-vs-ufdx-extraction-outputs/) are multiple extractions merged into one case. UFD does not contain file data, only information about the extraction.

## Test Data

UFDR file is from Cellerbite Reader - [Josh Hickman Android 12 image](https://thebinaryhick.blog/2021/12/17/android-12-image-now-available/). [Here](https://www.mediafire.com/file/4s19ubpptbukd6b/Android_12_Cellebrite_Reader.zip/file) is the specific file I am using.

## Initial Analysis

UFDR file type:

```
file Android_12_Cellebrite_Reader.ufdr 
Android_12_Cellebrite_Reader.ufdr: Zip archive data
```

UFDR header:

```
xxd Android_12_Cellebrite_Reader.ufdr | head
00000000: 504b 0304 2d00 0008 0000 526e 9053 8116  PK..-.....Rn.S..
```

So we can see that a UFDR is a standard zip container. ALEAPP/iLEAPP support processing zip containers directly. However, they will reject the file based on the extension.

If we open the archive, we can see a file structure:

* chats
* email
* files
  * Application
  * Archives
  * Audio
  * Configuration
  * Database
  * Document
  * Exchange
  * Image
  * Text
  * Video
* report.xml
* ThumbnailCache.s3dd

We already have a problem - ufdr does not preserve full paths of files in the suspect system. The folder structure above is pre-categorized. ALEAPP/iLEAPP uses both file paths and files names to load specific parsers. *Some* parsers will work, but most will not.

## Using ufdr with ALEAPP

Change the file extension from *Android_12_Cellebrite_Reader.ufdr* to *Android_12_Cellebrite_Reader.zip*. Update ALEAPP to 2.0.05. Run the ALEAPP GUI. Select our zip file. Select the output location.

### Results

ALEAPP processed the zip file, but - as expected - it could not find most of the artifacts
without the full path information.

See the processed log excerpt below:

```
No files found for playgroundVault -> */playground.develop.applocker/shared_prefs/crypto.KEY_256.xml

No files found for playgroundVault -> */applocker/vault/*

No files found for etc_hosts -> */system/etc/hosts

Files for **/threads_db2* located at /home/joshua/Desktop/Cellebrite_Reader/ALEAPP_Reports_2022-02-02_Wednesday_173349/temp/files/Database/threads_db2

Files for **/threads_db2* located at /home/joshua/Desktop/Cellebrite_Reader/ALEAPP_Reports_2022-02-02_Wednesday_173349/temp/files/Uncategorized/threads_db2-uid
```

Anything that relies only on a file name was detected. Any path information - like applocker - was not detected.

From our test data, Facebook databases, TikTok databases, and general SQLite Journal & WAL were parsed correctly. All other artifacts were missed.

## Possible solutions

The UFDR contains a file name "report.xml" This file contains the full path of the original file (path=) as well as the new, categorized path (Local Path). See the file entry from report.xml below.

```
<file fs="Google_G013A Pixel 3.zip" fsid="3e01dece-71b0-410c-8a3b-5a308087a4d9" path="/data/user/0/com.android.vending/files/experiment-flags-regular-thisisdfir%40gmail.com" size="84143" id="140a2955-fc27-4785-86cf-6594f9fd2199" extractionId="0" deleted="Intact" embedded="false" isrelated="True" source_index="88008">
          <accessInfo>
            <timestamp name="ModifyTime" format="TimeStampKnown" formattedTimestamp="2021-12-16T13:50:36+00:00">2021-12-16T13:50:36.000+00:00</timestamp>
          </accessInfo>
          <metadata section="File">
            <item name="Local Path" systemtype="System.String"><![CDATA[files\Application\experiment-flags-regular-thisisdfir%40gmail.com]]></item>
            <item name="SHA256" systemtype="System.String"><![CDATA[]]></item>
            <item name="MD5" systemtype="System.String"><![CDATA[c883b94868b01b64fbaa63bc8aabe1dc]]></item>
            <item name="Tags" systemtype="System.String"><![CDATA[Application]]></item>
          </metadata>
          <metadata section="MetaData">
            <item name="CoreFileSystemFileSystemNodeFileDataOffsetName" group="CoreFileSystemFileSystemNodeFileOffsetsCategory" systemtype="System.String"><![CDATA[0x259C657FC]]></item>
            <item name="CoreFileSystemFileSystemNodeCreationTime" group="CoreFileSystemFileSystemNodeDateTime" systemtype="System.String"><![CDATA[]]></item>
            <item name="CoreFileSystemFileSystemNodeModifyTime" group="CoreFileSystemFileSystemNodeDateTime" systemtype="System.String"><![CDATA[12/16/2021 1:50:36 PM(UTC+0)]]></item>
            <item name="CoreFileSystemFileSystemNodeLastAccessTime" group="CoreFileSystemFileSystemNodeDateTime" systemtype="System.String"><![CDATA[]]></item>
            <item name="CoreFileSystemFileSystemNodeDeletedTime" group="CoreFileSystemFileSystemNodeDateTime" systemtype="System.String"><![CDATA[]]></item>
            <item name="CoreFileSystemFileSystemNodeChangeTime" group="CoreFileSystemFileSystemNodeDateTime" systemtype="System.String"><![CDATA[]]></item>
            <item name="ReportTemplateFileSize" systemtype="System.String"><![CDATA[84143 Bytes]]></item>
            <item name="CoreFileSystemFileSystemNodeFileChunks" systemtype="System.String"><![CDATA[1]]></item>
          </metadata>
        </file>
```

If we want to use UFDR files, we need to reconstruct their original paths. That means either parsing *report.xml* first, reconstructing the paths, and placing the files where they go **OR** writing a special parser inside ALEAPP/iLEAPP that would map matching files from report.xml to their new "Local Path."

Both options seem possible. I guess a third-party path reconstruction tool might be the best since an investigator could use other third-party tools on the original structure.