#! /usr/bin/env raku

# No -u or -d flag --> use the built-in unique method...
multi sub MAIN (:$i) {
    lines.unique(as => $i ?? *.fc !! *.Str)».say;
}

# -u or -d flag --> we have to count explicitly...
multi sub MAIN (:$i, :$u, :$d where {$u ^^ $d}) {   # ^^ because flags are mutually exclusive
    # Lookup is case-insensitive under -i flag...
    my &lookup = $i ?? *.fc !! *.Str;

    # Acquire input and count occurrences of each line...
    my @lines = lines;
    my %count = bag @lines».&lookup;

    # Which lines to target...
    my &target = $d ?? { %count{lookup($^line)}  > 1 }
                    !! { %count{lookup($^line)} == 1 }

    # Identify appropriate lines and print them...
    @lines.unique(as => &lookup).grep(&target)».say;
}
