---
layout: single
title: "iLEAPP and RLEAPP updates"
permalink: /:year/:month/:title
date: "2022-08-17T16:11:22-05:00"
tags:
  - dfir
  - infosec
  - development
  - ileapp
  - rleapp
header:
  og_image: "/assets/images/logos/dfir_card.png"
  image: "/assets/images/posts/headers/pythonCode.jpg"
  caption: "Photo by [Shahadat Rahman](https://unsplash.com/@hishahadat?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/fast?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)"
modified_time:
---
 
Alex ([@kviddy](https://twitter.com/kviddy)) has been pushing some extremely useful updates to the open-source Android forensic tool - [ALEAPP](https://github.com/abrignoni/ALEAPP]. Specifically, they introduced modular artifact definitions and loadable profiles.

Modular artifact definitions mean that artifacts and their parsing code is now contained in one file. Drop a parser in the [scripts/artifacts](https://github.com/abrignoni/ALEAPP/tree/master/scripts/artifacts) folder, and it will be automatically detected. This detection is made possible by an artifact definition at the end of the script that looks like this:

```python
__artifacts__ = {
        "bashHistory": (
                "Bash History",
                ('**/.bash_history'),
                get_BashHistory)
}
```

First we specify that this is an artifact structure. Then we have the ```keyname``` bashHistory, the ```pretty name``` 'Bash History', the location(s) of the files to find which are regular expressions for the path and be a comma-separated list, and finally, we have the entry point into the parser script (get_SOMETHING).

Drop-in modules make development, maintenance, and portability much, much easier. It also enables loadable profiles...

Loadable profiles are found in the GUI version of ALEAPP (aleappGUI.py). Select which modules you want in your profile, then click "Save Profile." As more modules are added, this can help you to focus your investigation on only the modules you use the most. Note that if you select all modules, it will skip modules where no data is found. The speed up is not very significant, but there is some benefit to selecting only modules you need.

## iLEAPP and RLEAPP

These features are so useful to the community, so we decided to port them over to [iLEAPP](https://github.com/abrignoni/iLEAPP/pull/325) and [RLEAPP](https://github.com/abrignoni/RLEAPP/pull/111). Alex's code is so clean that the porting was very easy.

There were also some awesome [optimizations](https://github.com/abrignoni/ALEAPP/pull/280) added to ALEAPP by bconstanzo that improve processing speed. They have also been ported to iLEAPP and RLEAPP.

## What's next?

Now that artifact definitions are modular and profiles can be created to run at specific times, I would like to see a *core* LEAPP created. Porting changes duplicates work, and you can see how each project starts to drift slightly. Although each LEAPP project uses the same base code, eventually, small changes creep in that make maintaining the project harder.

### LEAPP Core?

There are at least two ways that a core LEAPP could be managed. The first is to create a 'LEAPP core' that becomes a [git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) for each of the current project repositories. You would clone the repository, pull in required sub-modules (the core), and then run/build per usual. This is fairly standard for larger projects, and it would keep the separate project concept while centralizing the core maintenance.

The second way is to combine all the LEAPPs into one project and use the new profile features to select modules based on the data type. This would be easier to maintain and probably easier for users but require much more profile support work upfront.

### Testing

I would also like to see more automated optimization and unit tests created. The testing bconstanzo did lead to some significant performance enhancements with very few changes. I think optimization and unit testing would be way easier with the new modular system.

It would also be cool if we can find a way to integrate testing with the [DFIR Artifact Museum](https://github.com/AndrewRathbun/DFIRArtifactMuseum).

## More to come

Ultimately, the decision is up to [Alexis](https://twitter.com/AlexisBrignoni). He has done an amazing job with the project, and I'm sure whatever he decides will be AWESOME. Thanks to everyone that works on all of these great projects.