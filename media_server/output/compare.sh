#!/usr/bin/env bash

if [[ -z $2 || ! -d ../$2 ]]; then
    echo "Fatal: invalid directory for ARG2"
    exit 1
fi
if [[ -z $1 || ! -x ../$1 ]]; then
    echo "Fatal: invalid script file for ARG1"
    exit 1
fi
cd .. && find $2 | bash $1 > output/result.html
cd output/
curl https://gist.githubusercontent.com/etcadinfinitum/962ee7ad3250122e36fb54572d399cac/raw/1127fb535bfa56fd3472824c818e33696a7b49f1/expected.html > expected.html
sed -e "s/^$//g; s/^\(\t\)*\(.*\)/\2/g" -i result.html
sed -e "s/^$//g; s/^\( \)*\(.*\)/\2/g" -i expected.html
vimdiff result.html expected.html
rm result.html expected.html