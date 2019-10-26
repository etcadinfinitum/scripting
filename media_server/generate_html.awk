#! /bin/env awk

# BEGIN block
BEGIN {
    FS="/"
    OFS="/"
    printf "<html>\n\t<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" />\n"
    printf "\t<body>\n\t\t<table border=\"1\">\n\t\t\t<tr>\n"
    printf "\t\t\t\t<th>Artist</th>\n\t\t\t\t<th>Album</th>\n\t\t\t\t<th>Tracks</th>\n\t\t\t</tr>\n"
}

{
    # exclude records that is not track data
    if (match($0, /.*\.ogg/) == 0) next
}

{
    if (artist == "") {
        artist=$3; album=$4
        # print opening HTML tags for artist, album, and track table
        rowspan = 1
        html = $3"</td>\n\t\t\t\t<td>"$4"</td>\n\t\t\t\t<td>\n"
        html = html"\t\t\t\t\t<table border=\"0\">\n"
    }
}

{
    if (artist != $3) {
        artist=$3; album=$4
        # end previous album inner table
        printf "\t\t\t<tr>\n\t\t\t\t<td rowspan=\""rowspan"\">"html
        printf "\t\t\t\t\t</table>\n\t\t\t\t</td>\n"
        # end previous table row with artist + album
        printf "\t\t\t</tr>\n"
        # begin new table row with artist + album
        rowspan = 1
        html = $3"</td>\n\t\t\t\t<td>"$4"</td>\n\t\t\t\t<td>\n"
        html = html"\t\t\t\t\t<table border=\"0\">\n"
    }
}


{
    if (album != $4) {
        album=$4
        rowspan++
        # end previous album inner table
        html = html"\t\t\t\t\t</table>\n\t\t\t\t</td>\n"
        # end previous table row with artist + album
        html = html"\t\t\t</tr>\n"
        # begin new table row with artist + album
        html = html"\t\t\t<tr>\n\t\t\t\t<td>"$4"</td>\n\t\t\t\t<td>\n"
        html = html"\t\t\t\t\t<table border=\"0\">\n"
    }
}

{
    track = $NF
    sub(/\.ogg/, "", track)
    tail = track"</a></td></tr>\n"
    # reassemble with output field separator "/"
    {$0=$0}
    html = html"\t\t\t\t\t\t<tr><td><a href=\""$0"\">"tail
}

# END block
END {
    # end previous album inner table
    printf "\t\t\t<tr>\n\t\t\t\t<td rowspan=\""rowspan"\">"html
    printf "\t\t\t\t\t</table>\n\t\t\t\t</td>\n"
    # end previous table row with artist + album
    printf "\t\t\t</tr>\n"
    # end full table and HTML document
    printf "\t\t</table>\n\t</body>\n</html>\n"
}
