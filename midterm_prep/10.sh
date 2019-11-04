#!/usr/bin/env bash

# Using wget or curl, download cnn.com webpage and 
# extract the links (the strings href="link" inside 
# the <a...> anchor tags.
# Hint: it may be easier to break the file into lines 
# and keep only the lines that contain anchor tags.

curl https://www.cnn.com/ | while read line; do
    # perl -lne 'print $1 if /href/'
    # perl -lne 'print $1 if /<a.+href="([^"]+)"/'
    awk 'BEGIN {FS=OFS="\n"}; s/(<a.+href=")([^"]+)(")/\2/p'
done
