#! /usr/bin/env perl -s

use 5.020;
use warnings;
use experimental 'signatures';

# This is the whole task...
print selected_lines_from(readline());


# Command-line options provided by -s in shebang
our ($i, $u, $d);

sub selected_lines_from (@input) {
    return grep { !singular($_) } selected(@input)  if $d;  # Repeated lines only
    return grep {  singular($_) } selected(@input)  if $u;  # Unique lines only
    return                        selected(@input);         # First repetition only
}

# Track how often specific lines were seen...
my %seen;

# Select unique lines...
sub selected (@input) {
    return grep { !$seen{$i ? lc($_) : $_}++ } @input;
}

sub singular ($line) {
    return $seen{$i ? lc($line) : $line} == 1;
}
