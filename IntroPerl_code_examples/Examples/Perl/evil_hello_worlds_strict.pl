#! /usr/bin/env perl

use strict;

# Evil old-style unsafe Perl code...

%worlds = (
        Mercury  => hot,
        Venus    => cloudy,
        Earth    => comfy,
        Mars     => red,
        Jupiter  => big,
        Saturn   => pretty,
        Neptune  => cold,
        Uranus   => rude,
        Pluto    => banished,
);

for $planet (sort keys %worlds) {
    print "$plant: $worlds{$planet}\n";
}



