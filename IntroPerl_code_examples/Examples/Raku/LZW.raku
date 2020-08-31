#! /usr/bin/env raku

sub compress(Str $uncompressed --> Seq)  {

    my %code-for = map { $^ASCII.chr => $^ASCII }, ^256;

    gather {
        my $already-seen = "";

        for $uncompressed.comb -> $next-char {
            my $now-seen = $already-seen ~ $next-char;

            if %code-for{$now-seen}:exists {
                $already-seen = $now-seen;
            }
            else {
                take %code-for{$already-seen};
                %code-for{$now-seen} = %code-for.elems;
                $already-seen = $next-char;
            }
        }

        take %code-for{$already-seen} if $already-seen ne "";
    }
}

say '# compress() returns a sequence of codepoints...';
my @codes = compress('To be or not to be. That be the question, matey!');
say @codes;
____________;

say '# Emit codepoints as Unicode characters...';
say @codes».chr.join;
____________;


















sub ____________ { say '_' x 50 }


