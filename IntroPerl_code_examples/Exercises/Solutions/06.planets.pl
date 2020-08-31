#! /usr/bin/env perl

use 5.010;
use warnings;

# The database...
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

# Use an array as an input-processing queue...
my @queue;

# Read in the next planet(s)...
while (print '> ' and my $next_planets = readline()) {

    # For each planet input...
    for my $next_planet (split /\s+/, $next_planets) {

        # Skip any that are already in the queue...
        next if grep { $_ eq $next_planet } @queue;

        # Otherwise, queue them up...
        push @queue, $next_planet;
    }

    # Grab the first item on the queue (if any)...
    my $curr_planet = shift @queue
        or next;

    # Describe the corresponding planet (if any)...
    say "$curr_planet: ", $worlds{$curr_planet} // '<no information available>';
}
