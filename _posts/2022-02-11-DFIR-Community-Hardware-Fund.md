---
layout: single
title: "DFIR Community Hardware Fund"
permalink: /:year/:month/:title
date: '2022-02-11T14:12:32-06:00'
tags:
  - infosec
  - dfir
  - community
header:
  image: /assets/images/posts/headers/togetherwecreate.jpg
  caption: "Photo by [My Life Through A Lens](https://unsplash.com/@bamagal?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/fast?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)"
modified_time: ""
---

A few days ago, Alexis Brignoni posted a [tweet](https://twitter.com/AlexisBrignoni/status/1490758627489103882?s=20&t=dPy6eilC_Vf0p5lK39WTXw) about the increased usage of the *Meta Quest 2* hardware. It's one of many devices that digital investigators will likely need to analyze in the near future. The problem is that devices like these are quite expensive for individual researchers. This means access to high-quality hardware information and data sources provided by a few [exceedingly generous individuals](https://thebinaryhick.blog/2021/12/17/android-12-image-now-available/).

One answer to this challenge is for the community to pool resources. Researchers interested in a specific topic can propose hardware to be studied. The community then contributes funding for the hardware they are most interested in researching. We then use funded projects to purchase the hardware, create and release free test data sets for the community, and manage hardware distribution to other researchers and labs for their testing. Theoretically, this would give the entire community much faster access to data sets. That means more eyes on new devices and a faster research-to-investigation pipeline.

## The Specifics

Steps required to make this work.

### List possible hardware

Members of the community should submit under-researched hardware likely to be important in real digital investigations in the near future. I have my own ideas, but I also have a lot of blind spots. For example, I have researched consumer IoT devices but know little about the needs for industrial IoT. It seems like drones are well-researched at this point. Is that true? This is where the community can list relevant hardware if you have recommendations, [email me](https://us5.list-manage.com/contact-form?u=3664f5bc2c4350bc7454f233d&form_id=42749486e45c8394701634ff776be7b8).

### Fund hardware

Hardware is listed on the [Community Fund](https://github.com/DFIRScience/DFIRCommunityHardwareFund) page, and anyone from the community can [donate](https://www.paypal.com/donate/?hosted_button_id=S3GXPSXT8QRGL) to a specific hardware project or the "general" fund. Money in the general fund will be used to fund any project that can be completed with general funds. For example, if the general fund has $10, and a $100 project reaches $90, then the general fund will be used to finish that project.

### Buy hardware

DFIR Science, LLC will buy the hardware using the project funding. We get the hardware and produce a realistic case study using hardware. We will attempt to produce disk and RAM images, network traffic captures, and cloud data dumps related to the hardware. Document all actions taken, and then publicly upload all the data. It could be cool to run a CTF or dev competition around the data if we're feeling super ambitious.

### Maintenance

After the initial data sets are created, the hardware is a community resource. Anyone that contributed to the community fund can request the hardware for non-destructive testing. They can then "borrow" the hardware for a certain period. They would be responsible for all shipping costs, but that would be way cheaper than buying some devices.

After a certain amount of time, or a major update (one year?), we would generate new case data based on the same device and release it to the community.

Also, after a certain amount of time, a lab could contribute a depreciated value to the fund to conduct destructive testing on the hardware. Not sure about this. Evaluated on a case-by-case basis.

## Is DFIR Science just trying to get free PlayStation?

I'm happy to receive a free PlayStation if you have one. But what we get is more and better data sets that help all researchers and investigators. Plus, these data sets could be used in training and education. Honestly, that's more useful for me than the hardware itself.

From the DFIR Science business side, I'll be putting in my own money for hardware, volunteering administration, coordination, and data set creation. Also, donations are probably categorized as "business income," so we will probably have a ~18% business tax liability on each hardware donation that we will be responsible for. If you would like to help with these costs, please consider [hiring me as a consultant](https://us5.list-manage.com/contact-form?u=3664f5bc2c4350bc7454f233d&form_id=42749486e45c8394701634ff776be7b8) or becoming a [Patron](https://patreon.com/dfirscience).

## Proposed Rules

* Anyone can request hardware to be funded. Create a pull request or [contact DFIRScience](https://dfir.science/contact).
* When donating, you can [select specific hardware projects to fund](https://www.paypal.com/donate/?hosted_button_id=S3GXPSXT8QRGL). Projects funded first will be processed first.
* Researchers and organizations that contribute to the fund can request the physical device for a limited time after the initial community data sets have been created.
* Any destructive research will need to be negotiated. Generally, destructive research should produce datasets or information freely available to the community. [Contact DFIRScience](https://dfir.science/contact)

## Conclusions

I have no idea if the community would be interested in this thing. As an independent researcher with no large grant funding coming in, this seems like a good thing for the community. However, I don't know if the idea, the rules, or the procedure make sense. Please let me know what you think on [Twitter](https://twitter.com/dfirscience), email, or the DFIR Discord. Any feedback is much appreciated.