---
layout: single
title: "Custom artifact creation"
date: '2020-10-27T21:19:30+09:00'
author: "Joshua I. James"
tags:
  - infosec
  - dfir
modified_time: ""
---

Last Wednesday, I woke up to the news that my custom (Magnet) artifact submission for Solid Explorer 2 was accepted. It’s exciting because I’d never created a custom artifact before, and the submission was worth a nice 50 points in the Magnet Weekly CTF - excellent! Given the week 3 question, I badly needed the points!

The whole process was to learn how artifact creation and submission work. I didn’t expect to be the first to submit an artifact. This post is the process that I used.

First, read the [week one post](https://dfir.science/2020/10/Magnet-CTF-Week-1-Timestamps-of-doom.html) detailing my analysis process. You’ll notice that I got hung up on artifacts from Solid Explorer 2. Specifically, the ```explorer.db``` contained paths for the hosts file. I believed (and still do!) that this DB proves copy/access after the original hosts file modified date!

Anyway, if we look at the tables in ```Explorer.db```, we find ```recent_files```. That table contains a path column (where the suspect hosts entries are) and a time column. The date is presented in “Unix Milliseconds (Java Time)(UTC)” according to DCode.

![SolidExplorer DB tables](/assets/images/posts/ExplorerDBTables.png)

This database contains some other potentially interesting tables like *bookmarks*, but it was not populated in the CTF. I extracted the database from the rest of the image.

Next, I went to the [Magnet Artifact Exchange](https://www.magnetforensics.com/artifact-exchange/). I’ve had *some* experience with Magnet tools before but never used or participated in the artifact exchange. It’s pretty straightforward. Create an account. Log in. Click on **Upload an artifact**. It would be a good idea to [read the docs](https://artifacts.magnetforensics.com/CommunitiesArtifactExchangeDocs) before that. There are many ways to create an artifact.

Ok, so we have our data of interest, and we have an account. All we need to do is create the *artifact definition*. For that, I ran over to Magnet’s [free tools](https://www.magnetforensics.com/resource-search-results/?category=free-tool) section (I looooovvveeee free tools). They provide many tools that I want to play with, but today we are interested in the [MAGNET Custom Artifact Generator](https://www.magnetforensics.com/resources/magnet-custom-artifact-generator/).

> The Magnet Custom Artifact Generator (MCAG) tool makes it easy to create custom artifacts for use within Magnet AXIOM from CSV (and other delimited files) and SQLite databases. This means you can now build your own custom artifacts to bring data into AXIOM from other sources without needing to know XML/Python or Magnet’s API for custom artifacts.

Hey hey! It takes in SQLite databases and outputs an artifact definition. Easy peasy. After installing MCAG it asks for the data you want to include. For an SQLite database you can select each table AXIOM should ingest. In each table, you can select the column and assign a specific data type. In my case, most of the data types were *automatically detected*. Once you have checked the few settings that are possible, click 
**Go**, and MCAG will output your artifact file. Mine looked like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Artifacts version="1.0">
  <!-- snip -->
  <Artifact type="SqliteArtifact" name="SolidExplorer 2 DB - recent_files" version="1.0">
    <Source type="FileName">explorer.db</Source>
    <Query>SELECT [path],[time] FROM recent_files</Query>
    <Fragments>
      <Fragment source="path" alias="path" datatype="String" category="None"/>
      <Fragment source="time" alias="time" datatype="DateTime" category="DateTime"/>
    </Fragments>
  </Artifact>
  <!-- snip -->
</Artifacts>
```

You then take the MCAG-generated file and the original data and create a ZIP file containing both. Upload that to the artifact exchange, give some context about why the artifact is useful, and then wait for it to be evaluated.

### Conclusions

Notice that the XML is very straightforward - it’s just defining an SQL query and describing what type of data it expects in return. The source of the artifact is the DB - treated like an artifact container. Run a query across the container to get the artifact, which should be this datatype. It’s not as difficult as I expected.

Like I said before, I had never used the Magnet Artifact Exchange before this. I love the idea of sharing artifacts in the community. I also strongly believe in a community standard for sharing knowledge. It may be like this, or something like the (Cyber-investigation Analysis Standard Expression)[https://github.com/casework/CASE], or maybe just blog posts. Whatever gets the knowledge out there!