#! /usr/bin/env perl

use 5.010;
use warnings;

# Retrieve window length...
my $WIN_LEN = $ENV{'LINES'} // qx{ tput lines };

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

    # If the response won't fit on a single screen, try to page it out...
    if (split(/\n/, $response) > $WIN_LEN && open my $pager, '|-', $PAGER) {
        print {$pager} $response;
    }
    else {
        print $response;
    }

    # And we're done...
    exit;
}

# Otherwise, give up...
say "Nothing found for '@ARGV'";
