#! /usr/bin/env perl

use 5.020;
use warnings;
use experimental 'signatures';

# Acquire items to be formatted...
my @items = readline();

# Strip surrounding whitespace...
s{^ \s* | \s* $}{}gx for @items;

# How wide? How separated?
my $MAX_WIDTH = 80;
my $GAP       = q{  };   # i.e. two spaces

# Collect the formatted lines...
my @formatted_lines;

# Start at maximum possible columns and work down to a solution...
for my $col_count (reverse 1..@items) {

    # Assemble in columns...
    @formatted_lines = columnify($col_count, @items);

    # How wide did we go?
    my $width = max( map {length($_)} @formatted_lines );

    # We're done only if everything fit (or there are no more alternatives)...
    last if $width < $MAX_WIDTH || $col_count == 1
}

# Print the results...
say for @formatted_lines;


sub columnify ($col_count, @items) {
    # How long is the longest column?
    my $col_len = int(@items / $col_count) + (@items % $col_count ? 1 : 0);

    # How many of the columns are that long?
    my $col_extras = @items % $col_count;
       $col_extras = $col_count if !$col_extras;  # ...because all columns are equal length

    # Distribute the items into their columns...
    my @lines;
    my @col_width = (0) x $col_count;
    for my $col_num (0..$col_count-1) {
        my $len = max(0, $col_num < $col_extras ? $col_len-1 : $col_len-2);
        for my $row (0..$len) {
            push @{$lines[$row]}, shift(@items) // "";
            $col_width[$col_num] = max($col_width[$col_num], length($lines[$row][-1]))
        }
    }

    # Pad each column...
    for my $col_num (0..$col_count-1) {
        for my $line (@lines) {
            $line->[$col_num] = sprintf("%-*s", $col_width[$col_num]//0, $line->[$col_num]//"");
        }
    }

    # Join each column with the appropriate gap to create lines...
    return map { join($GAP, @{$_}) } @lines;
}

# Return maximum of a list of numbers...
sub max (@data) {
    my $max = shift @data;
    for my $value (@data) {
        $max = $value if $max < $value;
    }
    return $max;
}
