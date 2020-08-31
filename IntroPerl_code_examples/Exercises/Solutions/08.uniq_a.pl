#! /usr/bin/env perl

use 5.010;
use warnings;

# Track the previously seen line...
my $prev_line = "";

# For each line input...
while (my $next_line = readline()) {

    # Nothing more to do if this line is identical to the previous...
    next if $prev_line eq $next_line;

    # Otherwise print and remember the newly seen line...
    print $next_line;
    $prev_line = $next_line;
}
