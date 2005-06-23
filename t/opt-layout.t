# Is the 'layout' option handled correctly?

use Test::More;
plan tests => 9;

BEGIN{ use_ok('Text::TypingEffort', 'effort') }

my $text = <<"";
This is a test of the Dvorak layout vs QWERTY
Hopefully this text will have enough differences between the two
keyboard layouts that I'll be able to find the differences in the tests.
If not, what on earth am I going to do?  I would be unable to test the
module! Durn!

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

    isa_ok( $a, 'HASH', "$msg: result is a hashref" );

    my $joules;
    my $others;
    if( $layout eq 'dvorak' ) {
        $joules = '9.4583';
        $others = {
                characters => 269,
                presses    => 286,
                distance   => 4010,
        };
    } else {
        $joules = '14.8963';
        $others = {
                characters => 269,
                presses    => 286,
                distance   => 6380,
        };
    }

    # floating point compare can be wierd
    my $energy = sprintf("%.4f", delete $a->{energy});
    is( $energy, $joules, "$msg: energy" );

    ok(
        eq_hash($a, $others),
        "$msg: characters, presses and distance"
    );
}
