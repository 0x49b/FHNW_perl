#! /usr/bin/env perl

use 5.020;
use warnings;
use experimental 'signatures';

# The obvious algorithm is to generate all possible permutations of
# the tiles and then select those that actually appear in the dictionary.
# However, this approach performs poorly (and does not scale)
# due to the combinatorial explosion of possible words to be checked
# (Try replacing letters with blanks, and see how much longer it takes)


# Decode command-line argument and convert letters to uppercase...
my @letters = map   { uc($_) }
              grep  /\S/,
              split //,
              shift @ARGV;

# Build a look-up table of all possible combinations...
my @candidates = permute(@letters);
my %possible;
@possible{map {lc($_)} @candidates} = @candidates;

# Connect to dictionary...
open my $dict_handle, '<', '../Testdata/scrabble_dict'
    or die "Couldn't open dictionary file: $!";

# Set up a pager, if possible...
my $pager;
if (!open $pager, '|-', $ENV{'PAGER'} // 'more') {
    $pager = *STDOUT;
}

# Filter entire dictionary for possible words,
# then sort alphabetically by length...
say {$pager} $_ for sort { length($b) <=> length($a) || $a cmp $b }
                    map  { $possible{lc($_)} || () }
                    map  { s{\n}{}r }
                    readline($dict_handle);


# Generate all permutations of all subsets of specified letters...
sub permute (@letters) {
    # Permutations of a single letter are easy...
    if (@letters == 1) {
        return 'a'..'z' if $letters[0] eq '_';
        return @letters;
    }

    # Otherwise, use a recursive algorithm...
    my @permutations;
    for my $i (keys @letters) {

        # Permutation of a list is each letter of the list...
        my $first = $letters[$i];

        # ...plus the recursive sub-permutation of the remaining letters...
        my @subpermutations = permute(@letters[0..$i-1,$i+1..$#letters]);
        push @permutations, @subpermutations;

        # Expand "blanks" to all possibilities...
        if ($first eq '_') {
            for my $replacement ('a'..'z') {
                push @permutations, map { $replacement . $_ } @subpermutations;
            }
        }
        else {
            push @permutations, map { $first . $_ } @subpermutations;
        }
    }

    return @permutations;
}
