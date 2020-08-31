#! /usr/bin/env perl

use 5.020;
use warnings;
use experimental 'signatures';

# Load data...
my @numbers = readline();
chomp @numbers;

# Report...
say "range   = ", min(@numbers), '..', max(@numbers);
say "average = ", mean(@numbers);
say "mode    = ", join(" and ", modes(@numbers));
say "median  = ", median(@numbers);


# Standard statistical functions...
sub mean (@numbers) {
    my $sum = 0;
    for my $next_num (@numbers) {
        $sum += $next_num;
    }
    return $sum / @numbers;
}

sub min (@numbers) {
    my $min = shift @numbers;
    for my $next_num (@numbers) {
        $min = $next_num if $next_num < $min;
    }
    return $min;
}

sub max (@numbers) {
    my $max = shift @numbers;
    for my $next_num (@numbers) {
        $max = $next_num if $next_num > $max;
    }
    return $max;
}

sub modes (@numbers) {
    # Build a frequency table...
    my %freq;
    $freq{$_}++ for @numbers;

    # Sort by frequency...
    my @vals_sorted_by_freq = sort {$freq{$b} <=> $freq{$a}}
                              keys %freq;

    # Find the maximal frequency...
    my $max_freq = $freq{ $vals_sorted_by_freq[0] };

    # Return all data with that frequency...
    return sort { $a <=> $b }
           grep { $freq{$_} == $max_freq }
           keys %freq;
}


sub median (@numbers) {
    # Find the middle of the sorted list...
    my @sorted_nums = sort { $a <=> $b } @numbers;
    my $middle = @numbers/2;

    # Return that element (or the mean of those elements)...
    return @sorted_nums % 2
               ? $sorted_nums[$middle]
               : mean( @sorted_nums[$middle-1, $middle] );
}
