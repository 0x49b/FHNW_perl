#! /usr/bin/env perl

use 5.020;
use warnings;
use experimental 'signatures';

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
        output("No such file\n");
        next FILENAME;
    }

    # Select the files that match the non-readable-or-larger-and-more-recent criterion...
    my @interesting_files = select_files($filename);

    # Print those files...
    OUTPUT:
    for my $filename (@interesting_files) {
        describe_file($filename);
    }
}

# Criterion for selecting files to report...
sub select_files ($filename) {
    return grep { !-r $_  ||  -s $_ > -s $filename && -M $_ > -M $filename }
           @dir_filenames;
}

# Generate and print the requested information...
sub describe_file ($filename) {

    # Print the filename and status...
    my $desc = sprintf("%12s: %s\n", (-r $filename ? 'readable' : 'not readable'), $filename);
    output($desc);

    # Also open the file...
    open my $filehandle, '<', $filename
        or next OUTPUT;

    # And print its first line...
    my $first_line = readline($filehandle);
    output("        > $first_line");
}

# Tee output to screen and to file...
sub output (@whatever) {
    print              @whatever;
    print {$save_file} @whatever;
}
