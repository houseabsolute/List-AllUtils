use strict;
use warnings;

# This is needed to produce sub redefined warnings from List::AllUtils when
# List::Util and List::MoreUtils export some of the same subs. I'm not sure
# why.
BEGIN {
    $^W++;
}

use Test::More 0.88;

my @warnings;

BEGIN {
    ## no critic (Variables::RequireLocalizedPunctuationVars)
    $SIG{__WARN__} = sub { push @warnings, join q{}, @_ };
}

## no critic (Modules::ProhibitMultiplePackages)
{
    package Foo;

    use List::AllUtils;
}

ok( !Foo->can('first'), 'no exports by default' );

{
    package Bar;

    use List::AllUtils qw( first any apply );

    sub test_first {
        return first { $_ > 1 } @_;
    }

    sub test_apply {
        return apply { $_ *= 2 } @_;
    }
}

ok( Bar->can('first'), 'explicitly import first' );
ok( Bar->can('any'),   'explicitly import any' );
ok( Bar->can('apply'), 'explicitly import apply' );
ok( !Bar->can('all'),  'did not import all' );

is(
    Bar::test_first( 1, 2, 3 ),
    2,
    'Bar::test_first returns expected value'
);

is_deeply(
    [ Bar::test_apply( 1, 2, 3 ) ],
    [ 2, 4, 6 ],
    'Bar::test_apply returns expected list'
);

{
    package Baz;

    use List::AllUtils qw( :all );

    sub test_first {
        return first { $_ > 1 } @_;
    }

    sub test_apply {
        return apply { $_ *= 2 } @_;
    }
}

ok( Baz->can('first'), 'imported everything, got first' );
ok( Baz->can('any'),   'imported everything, got any' );
ok( Baz->can('all'),   'imported everything, got all' );
ok( Baz->can('apply'), 'imported everything, got apply' );
ok( Baz->can('uniq'),  'imported everything, got uniq' );
ok( Baz->can('uniq_by'),  'imported everything, got uniq_by from UtilsBy' );

is(
    Baz::test_first( 1, 2, 3 ),
    2,
    'Baz::test_first returns expected value'
);

is_deeply(
    [ Baz::test_apply( 1, 2, 3 ) ],
    [ 2, 4, 6 ],
    'Baz::test_apply returns expected list'
);

{
    package ImportsAllSub;

    use List::AllUtils qw( all );
}

ok( ImportsAllSub->can('all'),   'ImportsAllSub has all()' );
ok( !ImportsAllSub->can('none'), 'ImportsAllSub does not have none()' );

ok(
    ( !grep {/Overwriting existing sub 'List::AllUtils.+'/} @warnings ),
    'no subroutines were redefined in List::AllUtils'
) or diag(@warnings);

done_testing();
