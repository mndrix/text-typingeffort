# Is the 'file' option handled correctly?

use Test::More;
use File::Temp;

plan tests => 6;

BEGIN{ use_ok('Text::Effort', 'effort') }

my $text = "   \tThe quick brown fox jumps over the lazy dog\n";
$text   .= "\t  The quick brown fox jumps over the lazy dog\n";

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
