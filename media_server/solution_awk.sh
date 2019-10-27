#!/bin/env bash

cat /dev/stdin | sort -t/ -k4 | sort -t/ -k3 | awk -f generate_html.awk
