#! /usr/bin/env raku
use v6.d;

# The database...
my %worlds is default('<no information available>')
    = (
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
loop {
    # Get next planet(s)...
    my $next_planets = prompt('> ')
        orelse last;

    # Add planets to queue unless they are already in the queue...
    @queue = unique |@queue, |$next_planets.words;

    # Grab the first item on the queue (if any)...
    my $curr_planet = @queue.shift
        orelse next;

    # Describe the corresponding planet (if any)...
    say "$curr_planet: %worlds{$curr_planet}";
}


