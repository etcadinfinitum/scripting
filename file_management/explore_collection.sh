#!env bash

function warmup() {
    echo -n "Total tracks: "
    echo `find -type f -iname "*.ogg" | wc -l`
    
    echo -n -e "\nTotal artists: "
    echo `find -mindepth 2 -maxdepth 2 -printf '%f\n' | sort | uniq | wc -l`
    
    echo -e "\nMulti-genre artists: "
    echo "`find -mindepth 2 -maxdepth 2 -printf '%f\n' | sort | uniq -d`"
    
    echo -e "\nMulti-disk albums: "
    echo "`find -mindepth 4 -maxdepth 4 -iname "dis??" | cut -d/ -f 4 | sort | uniq -d`"
}

function detailed() {
    echo -e "\nMulti-Genre Artists: "
    find -mindepth 2 -maxdepth 2 -printf '%f\n' | sort | uniq -d | while read artist; do
        echo "   $artist"
        find -iname "*$artist*" | cut -d/ -f 2 | sort | uniq | while read genre; do
            echo "      $genre"
        done
    done

    echo -e "\nMulti-Disk Albums:"
    find -mindepth 4 -maxdepth 4 -iname "dis??" | cut -d/ -f 3 | sort | uniq -d | while read artist; do
        echo "   $artist"
        find -type d -iname "*dis??" | grep "$artist" | cut -d/ -f 4 | sort | uniq | while read album; do
            echo "      $album"
        done
    done

    echo -e "\nPossible Duplicate Albums:"
    find -mindepth 3 -maxdepth 3 -type d | cut -d/ -f 4 | sort | uniq -d | while read album; do
        echo "   $album"
        find -type d -mindepth 3 -maxdepth 3 -iname "$album" | cut -d/ -f 2,3 --output-delimiter="	" | sort -k 2 | while read pair; do
            echo "      $pair"
        done
        echo
    done
        
}

path=Music
if [[ ! -d $path ]]; then
    echo -n "No ./Music directory exists. Please enter the path (relative or absolute) you would like to inspect: "
    read path
    if [[ ! -d $path ]]; then 
        echo "That path doesn't exist. Terminating."
        exit 1
    fi
else
    echo -n "A Music subdirectory exists here. If you want to use a different path, enter one now, or press enter to continue: "
    read path
    if [[ -z $path ]]; then
        path=Music
    elif [[ ! -d $path ]]; then 
        echo "That path doesn't exist. Terminating."
        exit 1
    fi
fi

cd $path
warmup $path
detailed $path
