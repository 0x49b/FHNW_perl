#! /usr/bin/env perl

use 5.010;
use warnings;

# Track the previously seen line...
my %seen;

# For each line input...
while (my $next_line = readline()) {

    # Nothing more to do if this line is identical to the previous...
    next if $seen{$next_line};

    # Otherwise print and remember the newly seen line...
    print $next_line;
    $seen{$next_line} = 1;
}
