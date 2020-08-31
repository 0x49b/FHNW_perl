#! /usr/bin/env raku

my @records = (
    { :Name<Damian Conway>, :Age(42), :ID('00012345')  },
    { :Name<Leslie Duvall>, :Age(29), :ID('668')       },
    { :Name<Sam Georgious>, :Age(-2), :ID('00000007')  },
);

my $invalid-record = &invalid-name | &invalid-age | &invalid-ID;

say 'Validating...';
report( $invalid-record(all @records) );

say 'Normalizing...';
normalize-data(all @records);

say 'Revalidating...';
report( $invalid-record(all @records) );










sub normalize-data (%record) {
    %record<Name>   .= subst(/<lower>/, {.uc}, :g);
    %record<Age>  max= 18;
    %record<ID>     .= fmt('%08d');
}

sub report ($outcome) {
    say "\tInvalid record ($outcome)" if $outcome;
}


sub invalid-name (%rec) { "Bad name: %rec.gist()" if %rec<Name> !~~ /\S/;        }
sub invalid-age  (%rec) { "Bad age:  %rec.gist()" if %rec<Age>  < 18;            }
sub invalid-ID   (%rec) { "Bad ID:   %rec.gist()" if %rec<ID>   !~~ /^\d ** 8$/; }

