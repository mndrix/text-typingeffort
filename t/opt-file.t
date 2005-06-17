# Is the 'file' option handled correctly?

use Test::More;
use File::Temp;

plan tests => 7;

BEGIN{ use_ok('Text::Effort', 'effort') }

my $text = "   \tThe quick brown fox jumps over the lazy dog\n";
$text   .= "\t  The quick brown fox  jumps over the lazy dog\n";

# make the temporary file
my $tmp = File::Temp->new();
print $tmp $text;
seek($tmp, 0, 0);  # rewind

# file parameter as an open filehandle
$effort = effort( file => $tmp );
results_ok( $effort, 'file=handle' );
close($tmp);

# file parameter as a filename
my $effort = effort( file  => "$tmp" );
results_ok( $effort, 'file=filename' );


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
