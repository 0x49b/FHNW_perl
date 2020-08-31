#! /usr/bin/env perl

use v5.32;

use experimental 'signatures';

sub initial_sample ($reaction_rate, $temperature, $pressure) {

     my ($package, $file, $line) = caller();

     return {
         rate    => $reaction_rate,
         temp    => $temperature,
         pres    => $pressure,
         _trail  => "\tinitiated ($file:$line) at ${\time()}\n",
     };
}

sub catalyze ($state, $catalyst, $rate_multiplier) {

     my ($package, $file, $line) = caller();

     return {
         %{$state},
         rate     => $state->{rate} * $rate_multiplier,
         catalyst => $catalyst,
         _trail   => $state->{_trail}
                   . "\tcatalysed to $state->{rate} "
                   . "with $catalyst ($file:$line) at ${\time()}\n",
     };
}

my $reaction = initial_sample(0.02, 283, 1.014);

$reaction = catalyze($reaction, "AlO2", 1.7);

sleep 2;

while ($reaction->{rate} < 5) {
    $reaction = catalyze($reaction, "CO2", 3.3);
}

$reaction = catalyze($reaction, "N2", 0);

say $reaction->{_trail};
















BEGIN {
    use experimental 'signatures';
    *CORE::GLOBAL::caller = sub ($n=0) {
        my ($package, $file, $line) = caller($n+1);
        $file =~ s{.*/}{}xms;
        return ($package, $file, $line);
    }
}
