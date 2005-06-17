# This test makes sure that the code from the SYNOPSIS works as
# advertised.

use Test::More;
plan tests => 4;

BEGIN{ use_ok('Text::Effort', 'effort') }

my $text = "The quick brown fox jumps over the lazy dog";
my $effort = effort( \$text );
isa_ok( $effort, 'HASH', 'result is a hashref' );

ok(
    eq_hash(
        $effort,
        {
            characters => 43,
            presses    => 44,
            distance   => 950,
        }
    ),
    'characters, presses and distance correct'
);

# floating point compare can be wierd
my $energy = sprintf("%.4f", $effort->{energy});
my $should = "2.1234";
is( $energy, $should, 'energy correct' );
