#!/bin/env bash

echo "#!/bin/env bash" > 05-rename.sh

find q\ 5/ -depth | while read file; do
    new=$(echo $file | awk -e 'BEGIN {FS=OFS="/"} sub(/ /, "", $NF); {$0=$0}')
    if [ -e "$new" ] || [ -n "$(cat 05-rename.sh | grep "$new")" ]; then
        echo "emitting $new from mv command due to existence"
    else
        echo "mv \"$file\" \"$new\"" >> 05-rename.sh
    fi
done
