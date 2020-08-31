#! /usr/bin/env perl

use 5.020;
use warnings;

#############################################################################
# More sophisticated solution. Numbered lines are outdented and numbers     #
# must be followed by--and may be preceded by--one or more punctuation      #
# characters. Alpha-bulleted lines start with a single lower-case alpha     #
# that must be followed by--and may be preceded by--one or more punctuation #
# characters. A new numbered bullet resets the next alpha bullet to 'a'.    #
#############################################################################

# Track the next available bullets...
my $next_num   = 1;
my $next_alpha = 'a';

# Track previous line indent...
my $prev_indent = 1e9;  # i.e. infinity

# Numerically bulleted lines look like this...
my $NUM_LINE = qr{
    ^
    (?<indent> \s*          )
    (?<left>   [[:punct:]]* )
    (?<num>    \d+          )
    (?<right>  [[:punct:]]+ )
    (?<etc>    .*           )
}xs;

# Alpha bulleted lines look like this...
my $ALPHA_LINE = qr{
    ^
    (?<indent> \s*          )
    (?<left>   [[:punct:]]* )
    (?<alpha>  [a-z]        )
    (?<right>  [[:punct:]]+ )
    (?<etc>    .*           )
}xs;

# Blank lines look like this...
my $BLANK_LINE = qr{^ \s* $}x;

# Process each line...
while (my $nextline = readline()) {

    # Empty lines are immediately printed and are ignored for indent tracking...
    if ($nextline =~ $BLANK_LINE) {
        print $nextline;
    }

    # Locate a numerically bulleted line and replace it...
    elsif ($nextline =~ $NUM_LINE && length($+{indent}) < $prev_indent) {
        my %cap = %+;  # Save named regex captures

        # Print the line, with its new numbered bullet...
        print $cap{'indent'} . $cap{'left'} . $next_num . $cap{'right'} . $cap{'etc'};

        # Update bullet number/letter, and track indent...
        $next_num++;
        $next_alpha = 'a';
        $prev_indent = length( $cap{'indent'} );
    }

    # Locate an alphabetically bulleted line and replace it...
    elsif ($nextline =~ $ALPHA_LINE) {
        my %cap = %+;  # Save named regex captures

        # Print the line, with its new numbered bullet...
        print $cap{'indent'} . $cap{'left'} . $next_alpha . $cap{'right'} . $cap{'etc'};

        # Update bullet letter, and track indent...
        $next_alpha++;
        $prev_indent = length( $cap{'indent'} );
    }

    # Just print the line as-is...
    else {
        print $nextline;

        # But still track indent...
        $prev_indent = length( $nextline =~ m{^(\s*)} ? $1 : "" );
    }
}
