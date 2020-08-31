#! /usr/bin/env perl

use v5.32;
use warnings;

my %worlds = (
        Mercury  => "Fleet in the heat",
        Venus    => "Beauty veiled in mystery",
        Earth    => "Cradle of life",
        Mars     => "Bringer of war",
        Jupiter  => "Lord of the system",
        Saturn   => "Ringéd wonder",
        Neptune  => "The not-particularly interesting",
        Uranus   => "Bringer of rude puns",
        Pluto    => "...is no longer a planet!",
);

for my $planet (sort keys %worlds) {
    say "Hello, $planet:\t$worlds{$planet}";
}

