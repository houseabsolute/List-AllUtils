use 5.10.0;

use strict;
use warnings;

use List::AllUtils qw/ pairmap sort_by /;

## no critic ( InputOutput::RequireCheckedSyscalls )

say join q{ }, @$_
    for sort_by { $_->[0] }
pairmap { [ $a => %$b ] } %List::AllUtils::EXPORTED_FUNCTIONS;
