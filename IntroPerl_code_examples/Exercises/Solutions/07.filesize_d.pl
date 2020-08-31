#! /usr/bin/env perl

use 5.010;
use warnings;

# Remember all the files in the current directory...
my @dir_filenames = `ls`;
chomp @dir_filenames;

# A file to write to...
open my $save_file, '>', "output_$$"
    or die "Couldn't open save file";

# Request filenames one at a time...
FILENAME:
while (print '> ' and my $filename = readline()) {
    chomp $filename;

    # Echo input to save-file...
    say {$save_file} "\n$filename";

    # Ignore invalid inputs...
    if (!-e $filename) {
        say {$_} 'No such file' for *STDOUT, $save_file;
        next FILENAME;
    }

    # Select the files that match the non-readable-or-larger-and-more-recent criterion...
    my @interesting_files = grep { !-r $_  ||  -s $_ > -s $filename && -M $_ > -M $filename }
                                 @dir_filenames;

    # Print those files...
    OUTPUT:
    for my $filename (@interesting_files) {
        # Print the filename and status...
        my $desc = sprintf("%12s: %s", (-r $filename ? 'readable' : 'not readable'), $filename);
        say {$_} $desc for *STDOUT, $save_file;

        # Also open the file...
        open my $filehandle, '<', $filename
            or next OUTPUT;

        # And print its first line...
        my $first_line = readline($filehandle);
        print {$_} "        > $first_line" for *STDOUT, $save_file;
    }
}

