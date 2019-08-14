---
layout: single
title: "DFIR already has Rapid Peer Review - we can do better"
date: '2018-06-28T08:41:42+09:00'
author: Joshua
tags:
- dfir
- infosec
- knowledge
modified_time: '2018-06-28T08:41:42+09:00'
---
# Introduction
Over the last few weeks [Brett Shavers](https://twitter.com/Brett_Shavers) has been
discussing how to publish DFIR research in a *better* way. I've been thinking about
this from the academic side for a long time.

In his [newest post](https://www.dfir.training/dfir-training-categories-k2/item/145-the-rapid-peer-review)
he describes [Jessica Hyde's](https://twitter.com/B1N2H3X) idea for "Rapid Peer Review".

**Disclaimer:** I don't know the details of the idea other than the bullet points given.

The problem with those bullet points is that *that is how the current academic peer review system works*.
For example, the excellent Journal of [Digital Investigation](https://www.journals.elsevier.com/digital-investigation/)
gives reviewers less than 30 days to submit their reviews. DI basically falls under the rules
of Rapid Peer Review.

## What practitioners want
From the discussion it looks like practitioners want:
* A single repository for trustworthy information (journal-esque)
* Easy to understand artifact lists, meanings and how to acquire (like a short paper)
* Published *almost* as easily as a blog post
* Referencing optional
* An easy way to be referenced (doi)
* Permanence - forever archived
* Open access - free

## What academics want
* Recognition of the publication by their university
* Easily referenced
* Free
* Permanence

# A solution to the review problem
The Rapid Peer Review has the same problem as current systems because it relies
on closed review by a few experts. The problem with academic peer review is not
*usually* the journal - it is how long the reviewers take to review. The reviewers
are busy and tend to hold the whole process up. But, a good review does take time.

Instead, for artifact papers / short papers we should use **open review**. After
an editor does a quick check, then the artifact paper is *published* with a review
tag. The editor can still assign specific reviewers, or the community at large
can comment on the paper. In this way, practitioners get immediate access to a
publication, and the author gets a "real" publication.

# A solution for academics
A publication (journal) needs to be indexed to be accepted as a 'real' publication in
many universities. Just publishing artifact lists is unlikely to get the publication
indexed. This means that academics would be less likely to publish artifact lists.
However, we want academics to publish artifact lists.

The solution is to run an academic journal that accepts artifact lists, short papers
and full papers. The journal would also accept full papers in a 'traditional' style.
If the journal maintains publication for (I think) two years, then it can apply for
academic indexing.

Once the journal is indexed, authors will get more credit for their publications,
including artifact lists. I think a lot of researchers would go this route.

# A solution for archiving
When this system is created, we don't want all the work to be lost if the journal
dies. There are two good options that I can see.

The first is just archiving everything to a GitHub open repository. When papers are
published, that whole "issue" gets wrapped up and copied to GitHub. Assuming open
repositories stay free, this is a good long-term solution for archiving a journal.

Also / alternatively is the [CLOCKSS](https://www.clockss.org/clockss/Home)/LOCKSS system.
This is an auto-archive that will redirect journal meta-data (see below) to a permanent
archive if the journal dies. This method costs some cash, but it is a great backup.

# A solution for referencing
It is really important for any work to be easily referenced. Currently DOI numbers
are the standard way to reference academic works. DOIs could be given to almost
any resource.

All resources related to this project should get DOI numbers pointing to the resource.
The DOI would also be used to maintain permanence with systems like CLOCKSS.

# A management system
All of this implies that the group can keep track of publishing workflows, DOIs,
links to resources, versions, etc etc. I'm currently installing [Open Journal Systems](https://pkp.sfu.ca/ojs/)
to make a demo for all of these workflows. With OJS, we can run self-hosted and
completely control the review and publishing process. OJS also supports standard
publishing features like DOI assignment, CLOCKSS and indexing.

## What else is needed
If we maintain OJS, the only other thing that is needed is practitioners and academics
contributing to the journal. Consistent publication can result in indexing. Indexing
can result in more contributions. With these tools, everything can be done for less than
a few hundred dollars per year.
