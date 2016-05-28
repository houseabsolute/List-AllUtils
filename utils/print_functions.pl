use 5.10.0;

use List::AllUtils qw/ pairmap sort_by /;

say join ' ', @$_ 
    for sort_by { $_->[0] } 
        pairmap { [ $a => %$b ] } %List::AllUtils::EXPORTED_FUNCTIONS;
