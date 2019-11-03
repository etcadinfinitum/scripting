#!/bin/env perl -n

BEGIN {
    %origin = {};
}

if (open(my $fh, '<:encoding(UTF-8)', $_)) {
    while (my $row = <$fh>) {
        chomp $row;
        my $source = /\/[^\/]$/;
        print $source;
        next unless /#include *"(.+)"/ and my $included;
        print $included;
        push @{$origin{$included}}, $source;
    }
}

END {
    foreach my $key (sort keys %origin) {
        print $key;
        foreach my $item(sort @{$origin{$key}}) {
            print "\t$item";
        }
    }
}
