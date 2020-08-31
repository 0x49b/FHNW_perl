#! /usr/bin/env perl

use 5.010;
use warnings;

# Remember all the files in the current directory...
my @dir_filenames = $^O eq 'MSWin32' ? `dir /b` : `ls`;
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

    # Select the files that match the larger-than criterion...
    my @larger_files = grep { -s $_ > -s $filename } @dir_filenames;

    # Print those files...
    for my $larger_file (@larger_files) {
        printf "%10d: %s\n", -s $larger_file, $larger_file;
    }
}
