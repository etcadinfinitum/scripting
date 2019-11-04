#!/bin/env bash

# Write a script that creates some files and 
# directories in a directory tree below the current 
# directory. The files and directories should have 
# spaces in their names (use mkdir and touch).

for i in {1..10}; do
    mkdir -p q\ 5/dir\ $i
    mkdir -p q\ 5/di\ r$i
done

find q\ 5 -type d | while read dir; do
    for i in {11..20}; do
        touch "$dir/file $i"
        touch "$dir/fi le$i"
    done
done

