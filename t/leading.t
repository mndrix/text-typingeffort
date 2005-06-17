# Is leading whitespace really ignored?

use Test::More;
plan tests => 4;

BEGIN{ use_ok('Text::Effort', 'effort') }

my $text = "   \tThe quick brown fox jumps over the lazy dog\n";
$text   .= "\t  The quick brown fox jumps over the lazy dog\n";
my $effort = effort( \$text );
isa_ok( $effort, 'HASH', 'result is a hashref' );

ok(
    eq_hash(
        $effort,
        {
            characters => 86,
            presses    => 88,
            distance   => 1900,
        }
    ),
    'characters, presses and distance correct'
);

# floating point compare can be wierd
my $energy = sprintf("%.4f", $effort->{energy});
my $should = "4.1234";
is( $energy, $should, 'energy correct' );
