#! /usr/bin/env perl

use 5.028;
use warnings;
use experimentals;

# The less-than-obvious algorithm walks through the dictionary
# checking whether each word can be formed by the available tiles
# It performs (and scales) much better than the previous algorithm


# Where to get the candidate words...
my $DICT = '../TestData/scrabble_dict';

# Table of values of letters in English Scrabble...
my %VALUE_OF = (
    map({ $_ => 1  } qw< A E I L N O R S T U >),
    map({ $_ => 2  } qw< G D                 >),
    map({ $_ => 3  } qw< B C M P             >),
    map({ $_ => 4  } qw< F H V W Y           >),
    map({ $_ => 5  } qw< K                   >),
    map({ $_ => 8  } qw< J X                 >),
    map({ $_ => 10 } qw< Q Z                 >),
);

# Start letter frequency counts at zero...
state %ZERO_COUNTS = map { $_ => 0 } 'A'..'Z', '_';

# How to highlight blanks...
my @HIGHLIGHT = 'underline bold blue';

# Determine how many of each letter we have to work with...
my %tile_count = count_of(uc $ARGV[0]);

# Open the dictionary...
open my $dict_fh, '<', $DICT
    or die "Can't open dictionary file: $!";

# Consider each word in the dictionary...
my @matches;
CANDIDATE:
while (my $candidate = readline($dict_fh)) {
    $candidate = uc $candidate;
    chomp $candidate;

    # What letters does this word require?
    my %candidate_count = count_of($candidate);

    # Check that each required letter is available in the set of tiles...
    my $missing = 0;
    my %blanks = %ZERO_COUNTS;
    for my $letter (keys %candidate_count) {
        if ($tile_count{$letter} < $candidate_count{$letter}) {
            my $blanks_needed  = $candidate_count{$letter} - $tile_count{$letter};
            $missing          += $blanks_needed;
            $blanks{$letter}   = $blanks_needed;

            next CANDIDATE if $missing > $tile_count{'_'};
        }
    }

    # Highlight blanks by lowercasing them...
    $candidate =~ s{(.)}{ $blanks{$1}-- > 0 ? lc $1 : $1 }ge;

    # Keep feasible words...
    push @matches, $candidate;
}


# Set up a pager, if possible...
my $pager;
if (!open $pager, '|-', $ENV{'PAGER'} // 'more') {
    $pager = *STDOUT;
}

# Print out matches sorted alphabetically by score then length...
say {$pager} $_ for map  { sprintf("%3d  $_", score($_)) }
                    sort { score($b) <=> score($a) || length($b) <=> length($a) || $a cmp $b }
                    @matches;


# Generate a frequency table of letters in a word...
sub count_of ($word) {
    my %count = %ZERO_COUNTS;

    for my $letter (split //, $word) {
        $count{$letter}++;
    }

    return %count;
}


# Compute the score of a word (and memoize the scores...to optimize sorting)...
sub score ($word) {
    state %score_for;

    if (!exists $score_for{$word}) {
        $score_for{$word} = 0;
        for my $letter (split //, $word) {
            $score_for{$word} += $VALUE_OF{$letter} // 0;
        }
    }

    return $score_for{$word};
}
