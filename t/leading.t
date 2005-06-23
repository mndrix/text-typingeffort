# Is leading whitespace really ignored?

use Test::More;
plan tests => 3;

BEGIN{ use_ok('Text::TypingEffort', 'effort') }

my $text = "   \tThe quick brown fox jumps over the lazy dog\n";
$text   .= "\t  The quick brown fox jumps over the lazy dog\n";
my $effort = effort( \$text );
results_ok( $effort, 'leading whitespace' );

############### helper sub ###################
sub results_ok {
    my ($a, $msg) = @_;

    isa_ok( $a, 'HASH', "$msg: result" );

    # floating point compare can be wierd
    my $energy = sprintf("%.4f", delete $a->{energy});
    my $should = "4.7618";
    is( $energy, $should, "$msg: energy" );

    # now compare the hash
    ok(
        eq_hash(
            $a,
            {
                characters => 88,
                presses    => 90,
                distance   => 2040,
            }
        ),
        "$msg: characters, presses and distance"
    );
}
