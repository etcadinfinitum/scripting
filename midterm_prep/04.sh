#!/bin/env bash

# Download a randomly-selected C or C++ project. For 
# each .h file, list the header and source files that 
# #include it. 

find . -type f | perl includes.pl
