---
layout: posts
title: '[How to] Using Tesseract-OCR to extract text from images'
date: '2017-04-14T17:44:29+09:00'
author: Joshua
tags:
- Optical character recognition
- OCR
- dfir
- HowTo
modified_time: '2017-04-14T17:44:29+09:00'
---
I recently found a tutorial on [tesseract-ocr](https://diging.atlassian.net/wiki/display/DCH/Tutorial%3A+Text+Extraction+and+OCR+with+Tesseract+and+ImageMagick). I used tesseract a few years ago without much luck, but this time it was extremely easy.

I was dealing with a PDF file. I needed to try to auto-extract the text. We can try auto-extraction with pdftotext like so:

````
sudo apt install xpdf
pdftotext target.pdf out.txt
````

This command will extract any text embeded in the PDF (if it can). This method likely produces much better quality text than OCR. If it works, congrats! If not, let's get to it.

First, we need to convert the PDF into a high resolution image file. If you have imagemagick installed, you should have the 'convert' command (try 'which convert'). Once installed, run convert like so:

````
convert -density 300 target.pdf -depth 8 -strip -background white -alpha off out.tiff
````

With this command we are converting the PDF to a high-resolution TIFF image, removing alpha channels and making the background white. If it is a multi-page PDF document, the resulting TIFF will have each page as a layer. If you open it, you're likely only to see the top page. Not to worry, the rest of the text is still there.

Now we can run tesseract:

````
tesseract out.tiff output
````

tesseract will scan the out.tiff image, and save any detected text into "output.txt" <- notice how I did not added .txt. It will be added automatically.

If you want to run tesseract with different languages, you need to download the language training data. In ubuntu, you can install langauge packages. For example:

````
sudo apt install tesseract-ocr-kor
````

This will install the Korean language model. Alternatively, you can get tesseract and the language data from the [github repository](https://github.com/tesseract-ocr). Once the language data is installed, run it as so:

````
tesseract out.tiff -l kor output
````

This will select 'kor' (Korean) as the langauge. Unfortunately, you can only run one language model per document. If you want to combine then, you will likely have to re-train tesseract and feed it a dual-language model.

Check out my video below for detailed instructions on running tesseract-ocr.

{% include responsive-embed url="https://www.youtube.com/embed/QhJiOCwz-_I" ratio="16:9" %}
