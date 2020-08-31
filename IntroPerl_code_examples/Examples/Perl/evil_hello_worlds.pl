#! /usr/bin/env perl

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


