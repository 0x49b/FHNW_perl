#! /usr/bin/env perl

use v5.32;

use Data::Show;

my @array  = (101..110);
my %hash   = (a=>'aardvark', b=>'buffalo', c=>'cow');


show @hash{'a','b'};
show %hash{'a','b'};

show @array[0..3];
show %array[0..3];
























use IO::Page;
