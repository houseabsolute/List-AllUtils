# generate the prototypes for the main module 

use strict;
use warnings;

use 5.10.0;

use experimental qw/ postderef /;

use Data::Dumper;
use List::AllUtils;
use List::Util;
use List::SomeUtils;
use List::UtilsBy;

my %protos;
for my $function ( keys %List::AllUtils::EXPORTED_FUNCTIONS ) {
    my( $module ) = $List::AllUtils::EXPORTED_FUNCTIONS{$function}->@*;
    $protos{$function} = eval "prototype '${module}::$function'";
}

say Dumper(\%protos);

