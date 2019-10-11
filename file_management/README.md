# Exploring File Management and Directory Analysis

Lizzy Presland

Assignment 1 for CSS 490 

## Purpose

The purpose of this assignment is to gain experience writing shell 
pipelines to solve problems. A secondary goal is to introduce the 
concept of file names as data that can be manipulated.

### Problem Statement

We are given a directory tree of music files where the directory 
heirarchy encodes information about the tracks. It looks something 
like:

```
path/to/
└── Music
    └── genre
        └── artist
            ├── album
            │   └── files
            └── album_with_multiple_discs
                ├── disk1
                │   └── files
                └── disk2
                    └── files
```

###### Warmup

Using only the Unix core utilities and pipelines, write a script that 
produces a report with following information:

1. total number of tracks
2. number of distinct artists/bands
3. artists who have albums in more than one genre (in alphabetical order)
4. multi-disk albums (in alphabetical order)

###### Detailed Report

Produce a more-detailed report that lists the genres of multi-genre 
artists and the artists of multi-disk albums. Identify any apparently 
duplicated albums. 

## Implementation

### Usage

**The created script requires an input prompt.** The prompt is intended 
to give the user control over where the analysis is conducted. It 
operates as follows:

1. On script invocation, check whether an immediate subdirectory of the 
   current working directory called `Music/` exists.
    a.  If `./Music/` does exist, request confirmation that this directory 
        should be explored. This can be done by simply hitting enter without 
        any other input.
    b.  If `./Music/` does _not_ exist, request the path of the directory 
        which should be explored.
    c.  In either case, if a new directory is entered, the existence of 
        the directory will be checked and the script will terminate if 
        the directory does not exist.
2. `cd` into the indicated directory.
3. Perform the tree walking functions for both the basic and detailed 
   versions of the report. All output is sent to STDOUT by default.

### Test Data

#### Usage With Test Data

A set of test data was created to illustrate the functionality detailed 
under `Usage`. The `Music/` target folder for this dataset is intentionally 
nested to demonstrate that the script can function correctly if the 
folder of interest is not a direct descendant of the current working 
directory. Usage in this case is as follows:

```console
$ bash explore_collection.sh
A Music subdirectory exists here. If you want to use a different path, enter one now, or press enter to continue: test_data/Music
[...output...]
```

In its present state, the script is not clever enough to infer where 
a `./Music/` folder exists in the provided subdirectory and handle 
path resolution independent of the user. This has its own benefits and 
detriments:

* The user can specify any folder of interest, regardless of its naming 
  convention.
* The user must specify the parent folder's location exactly for the script 
  to produce expected results.

#### Test Data Findings

Besides handling directory nesting well, as described above, the test 
data shows that directory fields with double quotes (`"`) are handled 
appropriately and are escaped in the `find` and `echo` calls when the 
assigned variables are contained in double quotes. This is important 
for naming flexibility in the directory tree.

Additionally, the way files are counted compared to the way artist and 
album duplications are assessed is rather different. The existing 
script only counts total tracks where the located file is a file (and 
not a directory) and ends with the `.ogg` extension; by contrast, the 
analysis of albums and artists does not validate whether any files 
exist in the subtree with a `.ogg` extension. This is illustrated in 
the entries under `Music/indie-rock`; the album contained therein 
has files with the `.mp4` format, so the tracks are not included in 
the total count, but the album is listed as a possible duplicate and 
the artist is listed as multi-genre. There are tradeoffs with this 
design decision:

* The pipeline for artist and album analysis is less convoluted than it 
  would be otherwise.
* The `find` function for music tracks doesn't include documents that 
  exist under different filename extensions and are unlikely to be the 
  desired file type (e.g. PDF, text files, Markdown files).
* The album and artist analyses might be misrepresentative given that 
  the search criteria differs from the criteria used to locate music 
  tracks.
* A mixture of file formats for genuine music tracks cannot be handled 
  by the script in its current state.

_Note: some of the above issues would be easily remedied by allowing 
the inclusion of multiple file formats for tracks; a more robust 
approach would be to validate the existence of the desired file format(s)
in the located subtree before proceeding with artist/album analysis for 
that particular line item._
