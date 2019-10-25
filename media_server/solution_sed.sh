#!/bin/env bash

# get stdin
data=$(tee | sort -t/ -k4 | sort -t/ -k3)

# print boilerplate lines
echo -e "<html>\n\t<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" />\n"
echo -e "\t<body>\n\t\t<table border=\"1\">\n\t\t\t<tr>\n"
echo -e "\t\t\t\t<th>Artist</th>\n\t\t\t\t<th>Album</th>\n\t\t\t\t<th>Tracks</th>\n\t\t\t</tr>\n"

echo "$data" | cut -d/ -f 3 | uniq | while read artist; do
    if [[ -n $artist ]]; then
        new_artist=""
        # get number of albums for artist
        album_count=$(echo "$data" | grep "$artist" | grep ".ogg" | cut -d/ -f 4 | uniq | wc -l)
        
        echo "$data" | grep "$artist" | cut -d/ -f 4 | uniq | while read album; do
            if [[ -n $album ]]; then
                echo -e "\t\t\t<tr>"
                if [[ -z $new_artist ]]; then
                    echo -e "\t\t\t\t<td rowspan=\"$album_count\">$artist</td>"
                    new_artist=$artist
                fi
                echo -e "\t\t\t\t<td>$album</td>"
                echo -e "\t\t\t\t<td>\n\t\t\t\t\t<table border=\"0\">"
                echo "$data" | sed -n -r -e "s/.+\/($artist)\/($album)(\/.+\/|\/)(.+\.ogg)/\t\t\t\t\t\t<tr><td><a href=\"&\">\4<\/a><\/td><\/tr>/p"
                echo -e "\t\t\t\t\t</table>\n\t\t\t\t</td>"
                echo -e "\t\t\t</tr>"
            fi
        done
    fi
done

echo -e "\t\t</table>\n\t</body>\n</html>\n"
