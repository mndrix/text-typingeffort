# Is the 'layout' option handled correctly?

use Test::More;
plan tests => 7;

BEGIN{ use_ok('Text::Effort', 'effort') }

my $text = "   \tThe quick brown fox jumps over the lazy dog\n";
$text   .= "\t  The quick brown fox  jumps over the lazy dog\n";

# qwerty layout
$effort = effort( text=>$text, layout=>'qwerty' );
results_ok( $effort, 'qwerty', 'layout=qwerty' );

# unknown layout
$effort = effort( text=>$text, layout=>'this is not a layout name' );
results_ok( $effort, 'unknown', 'layout=unknown' );

# dvorak layout
$effort = effort( text=>$text, layout=>'dvorak' );
results_ok( $effort, 'dvorak', 'layout=dvorak' );


############### helper sub ###################
sub results_ok {
    my ($a, $layout, $msg) = @_;

    my $joules;
    my $others;
    if( $layout eq 'dvorak' ) {
        $joules = '4.1234';
        $others = {
                characters => 86,
                presses    => 88,
                distance   => 1900,
        };
    } else {
        $joules = '4.1234';
        $others = {
                characters => 86,
                presses    => 88,
                distance   => 1900,
        };
    }

    isa_ok( $a, 'HASH', "$msg: result is a hashref" );
    ok(
        eq_hash($a, $others),
        "$msg: characters, presses and distance"
    );

    # floating point compare can be wierd
    my $energy = sprintf("%.4f", $effort->{energy});
    is( $energy, $joules, "$msg: energy" );
}
