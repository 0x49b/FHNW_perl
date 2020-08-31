package My::Module v0.0.1;

use 5.026;
use warnings;
use experimentals;

use Exporter 'import';

our @EXPORT    = ( 'my_sub'       );
our @EXPORT_OK = ( 'my_other_sub' );

sub my_sub {
    say 'Mine! All mine! Bwah-ha-ha-hah!!!!!';
}

sub my_other_sub {
    say 'Mine too';
}

1; # Magic true value required at end of module
