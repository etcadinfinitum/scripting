#!/bin/env bash

# Write a script to rename the paths to remove spaces 
# or replace them with underscores. Make sure no file 
# gets "overwritten" by another one (e.g. both "ab c" 
# and "a bc"  map to "abc"). Make sure your data 
# generator script has cases that test this.

# underscores
find q\ 5 -depth | while read file; do
    new=$(echo $file | awk -F / -e 'BEGIN {OFS="/"} sub(/ /, "_", $NF); {$0=$0}')
    mv "$file" "$new"
done

