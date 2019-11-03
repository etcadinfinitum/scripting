#!/bin/env bash

# For each directory in the tree rooted at the current 
# directory, make sure only the owner has read, write, 
# or execute permissions.

find . -mindepth 1 -type d | while read dir; do
    chmod 770 $dir
done
