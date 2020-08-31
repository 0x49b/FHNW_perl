#! /usr/bin/env perl

use 5.010;
use warnings;

use List::Util qw< min max >;
use Statistics::Basic qw< mean mode median >;

# Load the values...
chomp(my @values = readline);

# Report...
say "range   = ", min(@values) . '..' . max(@values);
say "average = ", mean(@values);
say "mode    = ", mode(@values);
say "median  = ", median(@values);
