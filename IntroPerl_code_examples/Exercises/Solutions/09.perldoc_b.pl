#! /usr/bin/env perl

use 5.010;
use warnings;

# Look up how the user likes their pages paged...
my $PAGER = $ENV{'MANPAGER'} // $ENV{'PAGER'} // 'more';

# These are the candidates to look at, in order...
my @CANDIDATES  = (
    'perldoc -f',    # Check if the word is a function name first
    'perldoc -v',    # Otherwise, try variable names
    'perldoc',       # Otherwise, try the general look-up
    'perldoc -q',    # Otherwise, try the FAQ
    'man',           # Otherwise, try the system manpages
);

# Try all candidates, in sequence...
CANDIDATE:
for my $command (@CANDIDATES) {

    # Grab the response of the candidate...
    my $response = qx{ $command @ARGV 2>/dev/null };

    # Keep trying if there isn't any meaningful response...
    next CANDIDATE if $response =~ /^\s*$/;

    # If there was a response, page it out (if possible) and we're done...
    if (open my $pager, '|-', $PAGER) {
        print {$pager} $response;
    }
    else {
        print $response;
    }
    exit;
}

# Otherwise, give up...
say "Nothing found for '@ARGV'";
