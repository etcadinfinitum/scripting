#!/usr/bin/env bash

# List every file in the current directory that is not an executable 
# but contains a shebang. Add execute permission to those files.

ls -1 . | while read f; do 
    if [ ! -x "$f" ] && [ "$(head -n 1 $f | cut -c1-2)" == "#!" ]; then
        chmod a+x $f
        echo $f
    fi
done
