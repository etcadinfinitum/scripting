#!/usr/bin/env bash

find . -iname "*.awk" | while read file; do
    sed -e "s/#! *\/usr\/local\/bin\/gawk/#!\/usr\/bin\/gawk/g" -i $file
done
