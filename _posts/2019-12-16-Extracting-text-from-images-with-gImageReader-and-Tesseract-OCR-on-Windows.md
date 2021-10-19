---
layout: single
title: "Extracting text from images with gImageReader and Tesseract OCR on Windows"
date: '2019-12-16T20:56:57+09:00'

tags:
  - OCR
  - dfir
  - text analysis
  - image analysis
  - gImageReader
  - tesseract ocr
modified_time: ""
---

{% include video id="GMAZtpWQF0U" provider="youtube" %}

Shows how to use gImageReader GUI on Windows as a front-end, easier way to use Tesseract OCR. gImageReader lets you copy images or scans for optical character recognition. gImageReader allows you to select the specific text areas you want to focus OCR on, which is useful for multi-lingual documents.

We demonstrate OCR with gImageReader on a multi-lingual Korean and English document. We convert the image to text. Then use the built-in editor to fix the text while previewing the image.

This video shows the basic installation, configuration and usage of gImagerReader on Windows. If you are looking for an easy way to use Tesseract OCR, but do not like to use the command line, this is the tool for you.

### Forensic implications

While gImageReader is useful for easy optical character recognition, a digital investigatior is probably going to have better luck with a tool that can do batch processing, especially if that tool can be scripted. In that case, Tesseract OCR CLI version may work better for you. See the video [here](https://youtu.be/QhJiOCwz-_I) for Tesseract OCR CLI on Linux, and [here](https://youtu.be/rSKYTefQv5g) for Tesseract OCR CLI on Windows.

If you are just starting out in OCR, take gImageReader for a test-drive. It will give you an idea of what is possible out-of-the-box.
