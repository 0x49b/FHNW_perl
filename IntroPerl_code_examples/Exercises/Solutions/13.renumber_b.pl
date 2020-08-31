#! /usr/bin/env perl

use 5.020;
use warnings;

########################################################
# Very simple solution: assumes all numbered lines     #
# start with a number immediately followed by a period #
########################################################

# Track the next available bullet number...
my $nextnum = 1;

# Process each line...
while (my $nextline = readline()) {

    # If it's a numerically bulleted line, replace the number...
    if ($nextline =~ s{^ (\s*) (\d+) \. }{$1$nextnum.}x) {

        # Then increment the bullet number...
        $nextnum++;
    }

    # Print every line...
    print $nextline;
}

