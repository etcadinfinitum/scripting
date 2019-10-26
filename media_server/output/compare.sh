#!/usr/bin/env bash

cat $1 | sed -e "s/^$//g; s/^\(\t\)*\(.*\)/\2/g" > 1.html
cat expected.html | sed -e "s/^$//g; s/^\( \)*\(.*\)/\2/g" > expected_test.html
vimdiff 1.html expected_test.html
