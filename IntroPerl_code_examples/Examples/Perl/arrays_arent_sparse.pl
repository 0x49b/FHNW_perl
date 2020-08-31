#! /usr/bin/env perl

use v5.32;
use warnings;


my @dwarfs      = ("Happy", "Sleepy", "Grumpy", "Dopey", "Sneezy", "Bashful", "Doc");
my @deadly_sins = ("Gluttony", "Sloth", "Anger", "Envy", "Greed", "Lust", "Pride");


$dwarfs[13]      = 'Tyrion';
$deadly_sins[99] = 'Stupidity';

use Data::Show;

show @dwarfs;
show @deadly_sins;
























use IO::Page;
