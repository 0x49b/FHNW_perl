#! /usr/bin/env perl

use v5.32;
use warnings;

while (my $next_char = getc()) {
    if (rand > 0.5) {
        print uc($next_char);
    }
    else {
        print lc($next_char);
    }
}

