#! /usr/bin/env perl
use 5.020;
use warnings;
use experimental 'signatures';

########################################################
# Very simple solution: assumes all numbered lines     #
# start with a number immediately followed by a period #
#                                                      #
# Note: This version does not use regular expressions, #
#       which makes it much more verbose, much slower, #
#       and much less elegant than it could be.        #
########################################################

# Track the next available bullet number...
my $nextnum = 1;

# Process each line...
LINE:
while (my $nextline = readline()) {

    # Is this a numerically bulleted line???
    my ($pre_bullet, $bullet, $post_bullet) = find_numeric_bullet($nextline);

    # If it is, replace the bullet with the next sequential bullet number...
    if ($bullet) {
        $nextline = "$pre_bullet$nextnum.$post_bullet";
        $nextnum++;
    }

    # Print every line...
    print $nextline;
}


# Locate and decompose a bulleted line...
# [ Note, this is basically just implementing what would otherwise
#   be a very simple regular expression: /^ (\s*) (\d+.) (.*) /x   ]

sub find_numeric_bullet ($line) {
    my ($pre_bullet, $in_bullet, $post_bullet) = ("","","");

    # Walk through string, looking for a bullet...
    CHAR:
    for my $i (0..length($line)-1) {

        # Unpack the next character...
        my $nextchar = substr($line, $i, 1);

        # Are we still in leading whitespace before the bullet???
        if (!$in_bullet && ($nextchar eq ' ' || $nextchar eq "\t")) {
            $pre_bullet .= $nextchar;
        }

        # Are we still in the bullet???
        elsif (!$post_bullet && $nextchar ge '0' && $nextchar le '9') {
            $in_bullet .= $nextchar;
        }

        # Are we at the end of the bullet???
        elsif (!$post_bullet && $nextchar eq '.') {
            $in_bullet   .= $nextchar;
            $post_bullet  = substr($line, $i+1);
            last CHAR;
        }

        # Were we in fact not seeing a bullet at all???
        elsif (!$post_bullet) {
            return ($line, "", "");
        }

        # There are no other possibilities (we hope!)
        else {
            die "This can't be happening. Something's terribly wrong.";
        }
    }

    return ($pre_bullet, $in_bullet, $post_bullet);
}
