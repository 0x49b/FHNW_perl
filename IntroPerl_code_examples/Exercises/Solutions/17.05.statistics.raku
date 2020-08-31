#! /usr/bin/env raku
use v6.d;

# Read in all the values...
my @values = slurp.words».Numeric;

# Report...
say "range   = @values.min()..@values.max()";
say "average = ", @values.sum / @values;
say "mode    = ", @values.Bag.maxpairs.sort».key.join(' and ');
say "median  = ", .elems %% 2 ?? (.[*/2-1] + .[*/2])/2 !! .[*/2] with @values.sort;

