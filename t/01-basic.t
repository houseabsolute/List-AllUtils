use strict;
use warnings;

use Test::More 0.88;

{
    package Foo;

    use List::AllUtils;
}

ok( !Foo->can('first'), 'no exports by default' );

{
    package Bar;

    use List::AllUtils qw( first any );
}

ok( Bar->can('first'), 'explicitly import first' );
ok( Bar->can('any'),   'explicitly import any' );
ok( !Bar->can('all'),  'did not import all' );

{
    package Baz;

    use List::AllUtils qw( :all );
}

ok( Baz->can('first'), 'imported everything, got first' );
ok( Baz->can('any'),   'imported everything, got any' );
ok( Baz->can('all'),   'imported everything, got all' );

is(
    ( List::AllUtils::first { $_ > 5 } ( 1, 2, 5, 22, 7 ) ),
    22,
    'explicitly calling List::AllUtils::first produces the correct result'
);

ok(
    ( List::AllUtils::any { $_ > 5 } ( 1, 2, 5, 22, 7 ) ),
    'explicitly calling List::AllUtils::any produces the correct result'
);

done_testing();
