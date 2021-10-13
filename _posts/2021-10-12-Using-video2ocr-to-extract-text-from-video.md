---
layout: single
title: "Using video2ocr / Tesseract-OCR to extract text from video"
date: '2021-10-12T09:00:00-05:00'
author: "Joshua I. James"
tags:
  - tools
header:
  image: /assets/images/posts/headers/dsg-text.jpg
  caption: "Photo by [Clark Tibbs](https://unsplash.com/@clarktibbs?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/text?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)"
modified_time: ""
---

This video demonstrates how to use the Tsurugi Linux video2ocr script to extract text from video. video2ocr uses ffmpeg to create screenshots of a target video file, then converts the screenshots to greyscale and uses Tesseract-OCR to extract text from the resulting images. Digital investigations often benefit from optical character recognition (OCR) of images, PDFs and video. video2orc is a useful tool as long as you understand its limitations.

{% include video id="X6evUb01eEI" provider="youtube" %}

We demonstrate how use video2ocr, and show some of it's strenghts and weaknesses. A simple powerpoint video is used as a case study. 

Links:

* [Tsurugi Linux](https://tsurugi-linux.org/)