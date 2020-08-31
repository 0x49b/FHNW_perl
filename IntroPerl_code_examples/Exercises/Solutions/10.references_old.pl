#! /usr/bin/env perl

use 5.020;
use warnings;

my $scalar = 'scalar variable';
my @array  = qw( a r r a y v a r i a b l e );
my %hash   = ( 'h' => 'ash', 'v' => 'ariable' );

my $scalar_ref = \$scalar;
my $array_ref  = \@array;
my $hash_ref   = \%hash;


say 'ref($scalar_ref): ', ref($scalar_ref);
say '${$scalar_ref}: ', ${$scalar_ref};
print eval { @{$scalar_ref} } // $@;
print eval { %{$scalar_ref} } // $@;
say '_' x 50;

say 'ref($array_ref):       ', ref($array_ref);
say '@{$array_ref}:         ', join ',', @{$array_ref};
say '${$array_ref}[0]:      ', join ',', ${$array_ref}[0];
say '$#{$array_ref}:        ', join ',', $#{$array_ref};
say '@{$array_ref}[1,2,3]:  ', join ',', @{$array_ref}[1,2,3];
say '%{$array_ref}[1,2,3]:  ', join ',', %{$array_ref}[1,2,3];
print eval { ${$array_ref} } // $@;
print eval { %{$array_ref} } // $@;
say '_' x 50;

say 'ref($hash_ref):           ', ref($hash_ref);
say 'keys %{$hash_ref}:        ', join ',', keys %{$hash_ref};
say '${$hash_ref}{"h"}:        ', join ',', ${$hash_ref}{'h'};
say '@{$hash_ref}{"v", "h"}:   ', join ',', @{$hash_ref}{'v', 'h'};
say '%{$hash_ref}{"v", "h"}:   ', join ',', %{$hash_ref}{'v', 'h'};
print eval { ${$hash_ref} } // $@;
print eval { @{$hash_ref} } // $@;
say '_' x 50;
