#!/usr/bin/env perl -n

BEGIN {
    print "<html>\n\t<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" />\n";
    print "\t<body>\n\t\t<table border=\"1\">\n\t\t\t<tr>\n";
    print "\t\t\t\t<th>Artist</th>\n\t\t\t\t<th>Album</th>\n\t\t\t\t<th>Tracks</th>\n\t\t\t</tr>\n";
    %files = {};
}

next unless /.*\.ogg/;
@path = split(/\//);
# HTML substitution
$_ =~ s/"/\\"/g;
$path[2] =~ s/&/&amp;/g;
$path[2] =~ s/"/&quot;/g;
$path[3] =~ s/&/&amp;/g;
$path[3] =~ s/"/&quot;/g;
$path[-1] =~ s/&/&amp;/g;
$path[-1] =~ s/"/&quot;/g;
# embed all features of interest into hash
$files{$path[2]}{$path[3]}{$path[-1]} = $_;

END {
    chomp(%files);
    foreach my $artist (sort keys %files) {
        chomp(%{$files{$artist}});
        $count = keys %{$files{$artist}};
        my $print_count = "";
        foreach my $album (sort keys %{@files{$artist}}) {
            chomp(%{$files{$artist}{$album}});
            print "\t\t\t<tr>\n";
            if ($print_count eq "") {
                print "\t\t\t\t<td rowspan=\"$count\">$artist</td>\n";
                $print_count = "no";
            }
            print "\t\t\t\t<td>$album</td>\n";
            print "\t\t\t\t<td>\n\t\t\t\t\t<table border=\"0\">\n";
            foreach my $track (sort keys %{$files{$artist}{$album}}) {
                chomp(%{$files{$artist}{$album}{$track}});
                print "\t\t\t\t\t\t<tr><td><a href=\"$files{$artist}{$album}{$track}\">";
                chomp($track);
                print "$track</a></td></tr>\n";
            }
            print "\t\t\t\t\t</table>\n\t\t\t\t</td>\n\t\t\t</tr>\n";
        }
        print "\t\t\t\t</td>\n\t\t\t</tr>\n";
    }
    print "\t\t</table>\n\t</body>\n</html>\n";
}
