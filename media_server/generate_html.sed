#!/usr/bin/env sed -n -e

# match regexp
s/.+\/($artist)\/($album)\/[^\/]+\/?(.+\.ogg)/\t\t\t\t\t\t<tr><td><a href=\"&\">\3<\/a><\/td><\/tr>/g
p
