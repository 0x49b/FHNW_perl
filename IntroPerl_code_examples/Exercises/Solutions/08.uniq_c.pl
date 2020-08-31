#! /usr/bin/env perl -s

use 5.016;
use warnings;

# Command-line option provided by -s on shebang line
our $i;

# Track the previously seen line...
my %seen;

# For each line input...
while (my $next_line = readline()) {
    # Nothing more to do if this line is identical to the previous...
    # (use fc() to fold case of each line when -i flag is specified)
    next if $seen{$i ? fc($next_line) : $next_line};

    # Otherwise print and remember the newly seen line...
    print $next_line;
    $seen{$i ? fc($next_line) : $next_line} = 1;
}
