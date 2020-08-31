#! /usr/bin/env perl

use 5.010;
use warnings;

# Track the values...
my @values;

# Compile the statistics in these...
my ($min, $max, $sum, %freq);

# Load data, convert to numbers, track minimum, maximum, total, and frequency distribution
while (my $nextval = readline()) {

    # Skip empty lines, and numerify any others...
    next if $nextval eq "\n";
    $nextval = 0 + $nextval;

    # Remember this value...
    push @values, $nextval;

    # Is it minimal or maximal?
    $min = $nextval if !defined $min || $nextval < $min;
    $max = $nextval if !defined $max || $nextval > $max;

    # Track the total of all values...
    $sum += $nextval;

    # Track how often each value occurs...
    $freq{$nextval}++;
}

# Find values that have maximum frequency...
use List::Util 'max';
my $max_freq = max values %freq;

my  @vals_with_max_freq = sort { $a <=> $b }
                          grep { $freq{$_} == $max_freq }
                          keys %freq;

# Find median value (average them if two "middle" elements")....
my @sorted_vals = sort { $a <=> $b } @values;
my $middle = @values/2;
my $median = @sorted_vals % 2
                ?  $sorted_vals[$middle]
                : ($sorted_vals[$middle] + $sorted_vals[$middle-1]) / 2
                ;

# Report...
say "range   = $min..$max";
say "average = ", $sum/@values;
say "mode    = ", join(" and ", @vals_with_max_freq);
say "median  = $median";
