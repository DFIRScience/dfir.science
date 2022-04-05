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
echo "  og_image: /ssets/images/logos/dfir_logo_vert_fullcolor.png" >> $POST
echo "  image: /assets/images/posts/headers/dfirscicover.png" >> $POST
echo "  caption: \"Photo by [DFIRScience](https://dfir.science)\"" >> $POST
echo "modified_time: \"\"" >> $POST
echo "---" >> $POST
echo " " >> $POST
echo "{% include video id=\"XXX\" provider=\"youtube\" %}" >> $POST

code . $POST &
fi
