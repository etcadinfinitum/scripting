# Text Manipulation & Regular Expressions

Lizzy Presland

Assignment 2 for CSS 390 

## Purpose

The purpose of this assignment is to demonstrate adeptness at using 
regular expressions and on-the-fly text editing utilities, as well as 
the languages that support these objectives well (namely Perl, `sed`, 
and `awk`).

## Problem Statement

Generate a user-friendly HTML file to help users navigate the music 
collection we explored in the last assignment. Ensure that conventions 
of HTML are respected in the resulting text file and that the artist, 
album, and track details are rendered correctly.

## Reflection

I have included 3 implementations for the assignment:

* Perl
* `awk`
* `sed`

None of them are perfect, but I believe the `awk` and Perl 
implementations fall within the 90% Solution philosophy. The `sed` 
implementation is closer to 60%, and the performance of the script 
is fairly abysmal; it takes my machine several seconds to complete 
the text processing. 

The `awk` implementation makes interesting use of string concatenation 
capabilities and variable value persistence between implicit loops. 
These features are particularly useful for calculating the `rowspan` 
value desired for each artist. 

The Perl implementation creates a multi-tiered hash of the artists, 
albums, and tracks while iterating through the implicit loop and only 
creates the HTML text in the `END` block. This implementation allows 
for calculating the number of key-value pairs in the complete hash 
and for sorting keys.

Some brief checking was done to ensure minimal differences between 
the provided example and my solutions; I feel that both the Perl and 
`awk` solutions are sufficient. The code for the `sed` implementation 
leaves a lot to be desired.
