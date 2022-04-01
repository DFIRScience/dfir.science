#!/bin/bash

# A script to make a basic new post given a title

if [ "$1" ]; then

DATE=$(date --iso)
DATETIME=$(date --iso=seconds)
TITLE=$(echo "$1" | sed 's/ /-/g')
FILENAME="$DATE-${TITLE}.md"
POST="_drafts/$FILENAME"

echo "---" > $POST
echo "layout: single" >> $POST
echo "title: \"${1}\"" >> $POST
echo "permalink: /:year/:month/:title" >> $POST
echo "date: '$DATETIME'" >> $POST
#echo "author: \"Joshua I. James\"" >> $POST
echo "tags:" >> $POST
echo "  - infosec" >> $POST
echo "  - dfir" >> $POST
echo "header:" >> $POST
echo "  image: /assets/images/posts/headers/linuxCLI.jpg" >> $POST
echo "  caption: \"Photo by [Gabriel Heinzer](https://unsplash.com/@6heinz3r?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/fast?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)\"" >> $POST
echo "modified_time: \"\"" >> $POST
echo "---" >> $POST
echo " " >> $POST
echo "{% include video id=\"XXX\" provider=\"youtube\" %}" >> $POST

code . $POST &
fi
