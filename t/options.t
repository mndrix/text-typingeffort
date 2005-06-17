# Is the 'text' option handled correctly?

use Test::More;
plan tests => 7;

BEGIN{ use_ok('Text::Effort', 'effort') }

my $text = "   \tThe quick brown fox jumps over the lazy dog\n";
$text   .= "\t  The quick brown fox  jumps over the lazy dog\n";

# text parameter as a scalarref
my $effort = effort( text => \$text );
results_ok( $effort, 'text=ref' );

# text parameter as a scalar
$effort = effort( text => $text );
results_ok( $effort, 'text=scalar' );


############### helper sub ###################
sub results_ok {
    my ($a, $msg) = @_;

    isa_ok( $a, 'HASH', "$msg: result is a hashref" );
    ok(
        eq_hash(
            $a,
            {
                characters => 86,
                presses    => 88,
                distance   => 1900,
            }
        ),
        "$msg: characters, presses and distance"
    );

    # floating point compare can be wierd
    my $energy = sprintf("%.4f", $effort->{energy});
    my $should = "4.1234";
    is( $energy, $should, "$msg: energy" );
}
