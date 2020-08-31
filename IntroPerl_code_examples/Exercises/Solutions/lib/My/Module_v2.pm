package My::Module_v2 0.000001;

use 5.026;
use warnings;
use experimentals;

use Exporter::Attributes 'import';

sub my_sub :Exported {
    say 'Mine! All mine! Bwah-ha-ha-hah!!!!!';
}

sub my_other_sub :Exportable {
    say 'Mine too';
}

1; # Magic true value required at end of module

