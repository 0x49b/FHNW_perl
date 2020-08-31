#! /usr/bin/env perl

use v5.32;

use Data::Show;

my $scalar = 'string';
my @array  = (101..110);
my %hash   = (a=>'aardvark', b=>'buffalo', c=>'cow');


show $scalar;
show $array[0];
show $hash{'a'};

show @array;
show @array[0];
show @hash{'a'};

show %hash;

















use IO::Page;
