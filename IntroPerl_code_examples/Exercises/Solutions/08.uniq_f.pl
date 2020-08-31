#! /usr/bin/env perl -s

use 5.016;
use warnings;

# Command-line options provided by -s on shebang line
our ($i, $u, $d);

# Track the previously seen line...
my %seen;

# Load the entire input...
my @input  = readline();
my @output = grep { !$seen{$i ? fc($_) : $_}++ } @input;

# Display each unique line of input...
if ($d) {
    print grep { $seen{$i ? fc($_) : $_} > 1 } @output;    # Repeated lines only
}
elsif ($u) {
    print grep { $seen{$i ? fc($_) : $_} == 1 } @output;   # Unique lines only
}
else {
    print @output;                                          # First repetition only
}





