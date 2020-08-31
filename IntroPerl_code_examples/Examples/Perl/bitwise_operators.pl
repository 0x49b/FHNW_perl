#! /usr/bin/env perl

use v5.32;
use warnings;
use experimentals;

use Data::Show;

show "42" | "13" ;
show  42  |  13  ;


my $x = "42";
my $y = "13";

show $x | $y ;
my $x2 = 2 * $x;
show $x | $y ;
