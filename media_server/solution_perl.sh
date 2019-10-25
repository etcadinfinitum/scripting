#!/bin/env bash

cat /dev/stdin | sort -t/ -k4 | sort -t/ -k3 | perl generate_html.pl
