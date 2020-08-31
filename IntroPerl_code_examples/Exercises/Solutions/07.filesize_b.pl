#! /usr/bin/env perl

use 5.010;
use warnings;

# Remember all the files in the current directory...
my @dir_filenames = `ls`;
chomp @dir_filenames;

# Request filenames one at a time...
FILENAME:
while (print '> ' and my $filename = readline()) {
    chomp $filename;

    # Ignore invalid inputs...
    if (!-e $filename) {
        say 'No such file';
        next FILENAME;
    }

    # Select the files that match the non-readable-or-larger-and-more-recent criterion...
    my @interesting_files = grep { !-r $_  ||  -s $_ > -s $filename && -M $_ > -M $filename }
                                 @dir_filenames;

    # Print those files...
    for my $filename (@interesting_files) {
        printf "%12s: %s\n", (-r $filename ? 'readable' : 'not readable'), $filename;
    }
}
