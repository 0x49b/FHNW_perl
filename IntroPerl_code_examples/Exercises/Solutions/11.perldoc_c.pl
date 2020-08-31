#! /usr/bin/env perl

use 5.020;
use warnings;
use experimental 'signatures';

# These are the candidates to look at, in order...
my @CANDIDATES  = (
    'perldoc -f',    # First, check if the word is a function name
    'perldoc -v',    # Otherwise, try variable names
    'perldoc',       # Otherwise, try general look-up
    'perldoc -q',    # Otherwise, try FAQ
    'man',           # Otherwise, try system manpages
);

# If there is a response for any candidate, page it out and we're done...
CANDIDATE:
for my $command (@CANDIDATES) {
    page_and_exit( get_response_for($command) // next CANDIDATE );
}

# Otherwise, give up...
say "Nothing found for '@ARGV'";



sub get_response_for ($command) {

    # Grab the response of the candidate...
    my $response = qx{ $command @ARGV 2>/dev/null };

    # Keep trying if there isn't any meaningful response...
    return undef if $response =~ /^\s*$/;

    # Otherwise, we have our response...
    return $response;
}

sub page_and_exit ($response) {
    my $pager = open_pager($response);
    print {$pager} $response;
    exit;
}

sub open_pager ($response) {

    # No pager required if output is small enough...
    my $WIN_LEN = $ENV{'LINES'} // qx{ tput lines };
    return *STDOUT if split(/\n/, $response) <= $WIN_LEN;

    # Otherwise open and return pager filehandle (if possible)...
    my $PAGER = $ENV{'MANPAGER'} // $ENV{'PAGER'} // 'more';
    open my $pager, '|-', $PAGER
         or return *STDOUT;

    return $pager;
}
