# NAME

List::AllUtils - Combines List::Util and List::MoreUtils in one bite-sized package

# VERSION

version 0.09

# SYNOPSIS

    use List::AllUtils qw( first any );

    # _Everything_ from List::Util and List::MoreUtils
    use List::AllUtils qw( :all );

    my @numbers = ( 1, 2, 3, 5, 7 );
    # or don't import anything
    return List::AllUtils::first { $_ > 5 } @numbers;

# DESCRIPTION

Are you sick of trying to remember whether a particular helper is
defined in [List::Util](https://metacpan.org/pod/List::Util) or [List::MoreUtils](https://metacpan.org/pod/List::MoreUtils)? I sure am. Now you
don't have to remember. This module will export all of the functions
that either of those two modules defines.

Note that all function documentation has been shamelessly copied from
[List::Util](https://metacpan.org/pod/List::Util) and [List::MoreUtils](https://metacpan.org/pod/List::MoreUtils).

## Which One Wins?

Recently, [List::Util](https://metacpan.org/pod/List::Util) has started including some of the subs that used to
only be in [List::MoreUtils](https://metacpan.org/pod/List::MoreUtils). This module always exports the version provided
by [List::Util](https://metacpan.org/pod/List::Util).

The docs below come from [List::Util](https://metacpan.org/pod/List::Util) 1.31 and [List::MoreUtils](https://metacpan.org/pod/List::MoreUtils) 0.28.

# LIST-REDUCTION FUNCTIONS

The following set of functions all reduce a list down to a single value.

## reduce BLOCK LIST

Reduces LIST by calling BLOCK, in a scalar context, multiple times,
setting `$a` and `$b` each time. The first call will be with `$a`
and `$b` set to the first two elements of the list, subsequent
calls will be done by setting `$a` to the result of the previous
call and `$b` to the next element in the list.

Returns the result of the last call to BLOCK. If LIST is empty then
`undef` is returned. If LIST only contains one element then that
element is returned and BLOCK is not executed.

    $foo = reduce { $a < $b ? $a : $b } 1..10       # min
    $foo = reduce { $a lt $b ? $a : $b } 'aa'..'zz' # minstr
    $foo = reduce { $a + $b } 1 .. 10               # sum
    $foo = reduce { $a . $b } @bar                  # concat

If your algorithm requires that `reduce` produce an identity value, then
make sure that you always pass that identity value as the first argument to prevent
`undef` being returned

    $foo = reduce { $a + $b } 0, @values;             # sum with 0 identity value

The remaining list-reduction functions are all specialisations of this
generic idea.

## first BLOCK LIST

Similar to `grep` in that it evaluates BLOCK setting `$_` to each element
of LIST in turn. `first` returns the first element where the result from
BLOCK is a true value. If BLOCK never returns true or LIST was empty then
`undef` is returned.

    $foo = first { defined($_) } @list    # first defined value in @list
    $foo = first { $_ > $value } @list    # first value in @list which
                                          # is greater than $value

This function could be implemented using `reduce` like this

    $foo = reduce { defined($a) ? $a : wanted($b) ? $b : undef } undef, @list

for example wanted() could be defined() which would return the first
defined value in @list

## max LIST

Returns the entry in the list with the highest numerical value. If the
list is empty then `undef` is returned.

    $foo = max 1..10                # 10
    $foo = max 3,9,12               # 12
    $foo = max @bar, @baz           # whatever

This function could be implemented using `reduce` like this

    $foo = reduce { $a > $b ? $a : $b } 1..10

## maxstr LIST

Similar to `max`, but treats all the entries in the list as strings
and returns the highest string as defined by the `gt` operator.
If the list is empty then `undef` is returned.

    $foo = maxstr 'A'..'Z'          # 'Z'
    $foo = maxstr "hello","world"   # "world"
    $foo = maxstr @bar, @baz        # whatever

This function could be implemented using `reduce` like this

    $foo = reduce { $a gt $b ? $a : $b } 'A'..'Z'

## min LIST

Similar to `max` but returns the entry in the list with the lowest
numerical value. If the list is empty then `undef` is returned.

    $foo = min 1..10                # 1
    $foo = min 3,9,12               # 3
    $foo = min @bar, @baz           # whatever

This function could be implemented using `reduce` like this

    $foo = reduce { $a < $b ? $a : $b } 1..10

## minstr LIST

Similar to `min`, but treats all the entries in the list as strings
and returns the lowest string as defined by the `lt` operator.
If the list is empty then `undef` is returned.

    $foo = minstr 'A'..'Z'          # 'A'
    $foo = minstr "hello","world"   # "hello"
    $foo = minstr @bar, @baz        # whatever

This function could be implemented using `reduce` like this

    $foo = reduce { $a lt $b ? $a : $b } 'A'..'Z'

## sum LIST

Returns the sum of all the elements in LIST. If LIST is empty then
`undef` is returned.

    $foo = sum 1..10                # 55
    $foo = sum 3,9,12               # 24
    $foo = sum @bar, @baz           # whatever

This function could be implemented using `reduce` like this

    $foo = reduce { $a + $b } 1..10

## sum0 LIST

Similar to `sum`, except this returns 0 when given an empty list, rather
than `undef`.

# KEY/VALUE PAIR LIST FUNCTIONS

The following set of functions, all inspired by [List::Pairwise](https://metacpan.org/pod/List::Pairwise), consume
an even-sized list of pairs. The pairs may be key/value associations from a
hash, or just a list of values. The functions will all preserve the original
ordering of the pairs, and will not be confused by multiple pairs having the
same "key" value - nor even do they require that the first of each pair be a
plain string.

## pairgrep BLOCK KVLIST

Similar to perl's `grep` keyword, but interprets the given list as an
even-sized list of pairs. It invokes the BLOCK multiple times, in scalar
context, with `$a` and `$b` set to successive pairs of values from the
KVLIST.

Returns an even-sized list of those pairs for which the BLOCK returned true
in list context, or the count of the **number of pairs** in scalar context.
(Note, therefore, in scalar context that it returns a number half the size
of the count of items it would have returned in list context).

    @subset = pairgrep { $a =~ m/^[[:upper:]]+$/ } @kvlist

Similar to `grep`, `pairgrep` aliases `$a` and `$b` to elements of the
given list. Any modifications of it by the code block will be visible to
the caller.

## pairfirst BLOCK KVLIST

Similar to the `first` function, but interprets the given list as an
even-sized list of pairs. It invokes the BLOCK multiple times, in scalar
context, with `$a` and `$b` set to successive pairs of values from the
KVLIST.

Returns the first pair of values from the list for which the BLOCK returned
true in list context, or an empty list of no such pair was found. In scalar
context it returns a simple boolean value, rather than either the key or the
value found.

    ( $key, $value ) = pairfirst { $a =~ m/^[[:upper:]]+$/ } @kvlist

Similar to `grep`, `pairfirst` aliases `$a` and `$b` to elements of the
given list. Any modifications of it by the code block will be visible to
the caller.

## pairmap BLOCK KVLIST

Similar to perl's `map` keyword, but interprets the given list as an
even-sized list of pairs. It invokes the BLOCK multiple times, in list
context, with `$a` and `$b` set to successive pairs of values from the
KVLIST.

Returns the concatenation of all the values returned by the BLOCK in list
context, or the count of the number of items that would have been returned
in scalar context.

    @result = pairmap { "The key $a has value $b" } @kvlist

Similar to `map`, `pairmap` aliases `$a` and `$b` to elements of the
given list. Any modifications of it by the code block will be visible to
the caller.

## pairs KVLIST

A convenient shortcut to operating on even-sized lists of pairs, this
function returns a list of ARRAY references, each containing two items from
the given list. It is a more efficient version of

    pairmap { [ $a, $b ] } KVLIST

It is most convenient to use in a `foreach` loop, for example:

    foreach ( pairs @KVLIST ) {
       my ( $key, $value ) = @$_;
       ...
    }

## pairkeys KVLIST

A convenient shortcut to operating on even-sized lists of pairs, this
function returns a list of the the first values of each of the pairs in
the given list. It is a more efficient version of

    pairmap { $a } KVLIST

## pairvalues KVLIST

A convenient shortcut to operating on even-sized lists of pairs, this
function returns a list of the the second values of each of the pairs in
the given list. It is a more efficient version of

    pairmap { $b } KVLIST

# OTHER FUNCTIONS

## shuffle LIST

Returns the elements of LIST in a random order

    @cards = shuffle 0..51      # 0..51 in a random order

# List::MoreUtils FUNCTIONS

## any BLOCK LIST

Returns a true value if any item in LIST meets the criterion given through
BLOCK. Sets `$_` for each item in LIST in turn:

    print "At least one value undefined"
        if any { ! defined($_) } @list;

Returns false otherwise, or if LIST is empty.

## all BLOCK LIST

Returns a true value if all items in LIST meet the criterion given through
BLOCK, or if LIST is empty. Sets `$_` for each item in LIST in turn:

    print "All items defined"
        if all { defined($_) } @list;

Returns false otherwise.

## none BLOCK LIST

Logically the negation of `any`. Returns a true value if no item in LIST meets
the criterion given through BLOCK, or if LIST is empty. Sets `$_` for each item
in LIST in turn:

    print "No value defined"
        if none { defined($_) } @list;

Returns false otherwise.

## notall BLOCK LIST

Logically the negation of `all`. Returns a true value if not all items in LIST
meet the criterion given through BLOCK. Sets `$_` for each item in LIST in
turn:

    print "Not all values defined"
        if notall { defined($_) } @list;

Returns false otherwise, or if LIST is empty.

## true BLOCK LIST

Counts the number of elements in LIST for which the criterion in BLOCK is true.
Sets `$_` for  each item in LIST in turn:

    printf "%i item(s) are defined", true { defined($_) } @list;

## false BLOCK LIST

Counts the number of elements in LIST for which the criterion in BLOCK is false.
Sets `$_` for each item in LIST in turn:

    printf "%i item(s) are not defined", false { defined($_) } @list;

## firstidx BLOCK LIST

## first\_index BLOCK LIST

Returns the index of the first element in LIST for which the criterion in BLOCK
is true. Sets `$_` for each item in LIST in turn:

    my @list = (1, 4, 3, 2, 4, 6);
    printf "item with index %i in list is 4", firstidx { $_ == 4 } @list;
    __END__
    item with index 1 in list is 4

Returns `-1` if no such item could be found.

`first_index` is an alias for `firstidx`.

## lastidx BLOCK LIST

## last\_index BLOCK LIST

Returns the index of the last element in LIST for which the criterion in BLOCK
is true. Sets `$_` for each item in LIST in turn:

    my @list = (1, 4, 3, 2, 4, 6);
    printf "item with index %i in list is 4", lastidx { $_ == 4 } @list;
    __END__
    item with index 4 in list is 4

Returns `-1` if no such item could be found.

`last_index` is an alias for `lastidx`.

## insert\_after BLOCK VALUE LIST

Inserts VALUE after the first item in LIST for which the criterion in BLOCK is
true. Sets `$_` for each item in LIST in turn.

    my @list = qw/This is a list/;
    insert_after { $_ eq "a" } "longer" => @list;
    print "@list";
    __END__
    This is a longer list

## insert\_after\_string STRING VALUE LIST

Inserts VALUE after the first item in LIST which is equal to STRING.

    my @list = qw/This is a list/;
    insert_after_string "a", "longer" => @list;
    print "@list";
    __END__
    This is a longer list

## apply BLOCK LIST

Applies BLOCK to each item in LIST and returns a list of the values after BLOCK
has been applied. In scalar context, the last element is returned.  This
function is similar to `map` but will not modify the elements of the input
list:

    my @list = (1 .. 4);
    my @mult = apply { $_ *= 2 } @list;
    print "\@list = @list\n";
    print "\@mult = @mult\n";
    __END__
    @list = 1 2 3 4
    @mult = 2 4 6 8

Think of it as syntactic sugar for

    for (my @mult = @list) { $_ *= 2 }

## before BLOCK LIST

Returns a list of values of LIST up to (and not including) the point where BLOCK
returns a true value. Sets `$_` for each element in LIST in turn.

## before\_incl BLOCK LIST

Same as `before` but also includes the element for which BLOCK is true.

## after BLOCK LIST

Returns a list of the values of LIST after (and not including) the point
where BLOCK returns a true value. Sets `$_` for each element in LIST in turn.

    @x = after { $_ % 5 == 0 } (1..9);    # returns 6, 7, 8, 9

## after\_incl BLOCK LIST

Same as `after` but also includes the element for which BLOCK is true.

## indexes BLOCK LIST

Evaluates BLOCK for each element in LIST (assigned to `$_`) and returns a list
of the indices of those elements for which BLOCK returned a true value. This is
just like `grep` only that it returns indices instead of values:

    @x = indexes { $_ % 2 == 0 } (1..10);   # returns 1, 3, 5, 7, 9

## firstval BLOCK LIST

## first\_value BLOCK LIST

Returns the first element in LIST for which BLOCK evaluates to true. Each
element of LIST is set to `$_` in turn. Returns `undef` if no such element
has been found.

`first_val` is an alias for `firstval`.

## lastval BLOCK LIST

## last\_value BLOCK LIST

Returns the last value in LIST for which BLOCK evaluates to true. Each element
of LIST is set to `$_` in turn. Returns `undef` if no such element has been
found.

`last_val` is an alias for `lastval`.

## pairwise BLOCK ARRAY1 ARRAY2

Evaluates BLOCK for each pair of elements in ARRAY1 and ARRAY2 and returns a
new list consisting of BLOCK's return values. The two elements are set to `$a`
and `$b`.  Note that those two are aliases to the original value so changing
them will modify the input arrays.

    @a = (1 .. 5);
    @b = (11 .. 15);
    @x = pairwise { $a + $b } @a, @b;   # returns 12, 14, 16, 18, 20

    # mesh with pairwise
    @a = qw/a b c/;
    @b = qw/1 2 3/;
    @x = pairwise { ($a, $b) } @a, @b;  # returns a, 1, b, 2, c, 3

## each\_array ARRAY1 ARRAY2 ...

Creates an array iterator to return the elements of the list of arrays ARRAY1,
ARRAY2 throughout ARRAYn in turn.  That is, the first time it is called, it
returns the first element of each array.  The next time, it returns the second
elements.  And so on, until all elements are exhausted.

This is useful for looping over more than one array at once:

    my $ea = each_array(@a, @b, @c);
    while ( my ($a, $b, $c) = $ea->() )   { .... }

The iterator returns the empty list when it reached the end of all arrays.

If the iterator is passed an argument of '`index`', then it returns
the index of the last fetched set of values, as a scalar.

## each\_arrayref LIST

Like each\_array, but the arguments are references to arrays, not the
plain arrays.

## natatime EXPR, LIST

Creates an array iterator, for looping over an array in chunks of
`$n` items at a time.  (n at a time, get it?).  An example is
probably a better explanation than I could give in words.

Example:

    my @x = ('a' .. 'g');
    my $it = natatime 3, @x;
    while (my @vals = $it->())
    {
        print "@vals\n";
    }

This prints

    a b c
    d e f
    g

## mesh ARRAY1 ARRAY2 \[ ARRAY3 ... \]

## zip ARRAY1 ARRAY2 \[ ARRAY3 ... \]

Returns a list consisting of the first elements of each array, then
the second, then the third, etc, until all arrays are exhausted.

Examples:

    @x = qw/a b c d/;
    @y = qw/1 2 3 4/;
    @z = mesh @x, @y;       # returns a, 1, b, 2, c, 3, d, 4

    @a = ('x');
    @b = ('1', '2');
    @c = qw/zip zap zot/;
    @d = mesh @a, @b, @c;   # x, 1, zip, undef, 2, zap, undef, undef, zot

`zip` is an alias for `mesh`.

## uniq LIST

## distinct LIST

Returns a new list by stripping duplicate values in LIST. The order of
elements in the returned list is the same as in LIST. In scalar context,
returns the number of unique elements in LIST.

    my @x = uniq 1, 1, 2, 2, 3, 5, 3, 4; # returns 1 2 3 5 4
    my $x = uniq 1, 1, 2, 2, 3, 5, 3, 4; # returns 5

## minmax LIST

Calculates the minimum and maximum of LIST and returns a two element list with
the first element being the minimum and the second the maximum. Returns the
empty list if LIST was empty.

The `minmax` algorithm differs from a naive iteration over the list where each
element is compared to two values being the so far calculated min and max value
in that it only requires 3n/2 - 2 comparisons. Thus it is the most efficient
possible algorithm.

However, the Perl implementation of it has some overhead simply due to the fact
that there are more lines of Perl code involved. Therefore, LIST needs to be
fairly big in order for `minmax` to win over a naive implementation. This
limitation does not apply to the XS version.

## part BLOCK LIST

Partitions LIST based on the return value of BLOCK which denotes into which
partition the current value is put.

Returns a list of the partitions thusly created. Each partition created is a
reference to an array.

    my $i = 0;
    my @part = part { $i++ % 2 } 1 .. 8;   # returns [1, 3, 5, 7], [2, 4, 6, 8]

You can have a sparse list of partitions as well where non-set partitions will
be undef:

    my @part = part { 2 } 1 .. 10;          # returns undef, undef, [ 1 .. 10 ]

Be careful with negative values, though:

    my @part = part { -1 } 1 .. 10;
    __END__
    Modification of non-creatable array value attempted, subscript -1 ...

Negative values are only okay when they refer to a partition previously
created:

    my @idx  = ( 0, 1, -1 );
    my $i    = 0;
    my @part = part { $idx[$++ % 3] } 1 .. 8; # [1, 4, 7], [2, 3, 5, 6, 8]

# EXPORTS

This module exports nothing by default. You can import functions by
name, or get everything with the `:all` tag.

# SEE ALSO

`List::Util` and `List::MoreUtils`, obviously.

Also see `Util::Any`, which unifies many more util modules, and also
lets you rename functions as part of the import.

# BUGS

Please report any bugs or feature requests to
`bug-list-allutils@rt.cpan.org`, or through the web interface at
[http://rt.cpan.org](http://rt.cpan.org).  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

# AUTHOR

Dave Rolsky <autarch@urth.org>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Dave Rolsky.

This is free software, licensed under:

    The Artistic License 2.0 (GPL Compatible)
