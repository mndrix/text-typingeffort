# Is the 'text' option handled correctly?

use Test::More;
plan tests => 2;

BEGIN{ use_ok('Text::TypingEffort', 'effort') }

my $text = "   \tThe quick brown fox jumps over the lazy dog\n";
$text   .= "\t  The quick brown fox jumps over the lazy dog\n";

my %ok = (
    characters => 88,
    presses    => 90,
    distance   => 2040,
    energy     => 4.7618,
);

# text parameter as a scalarref
my $effort = effort( text => \$text );
$effort->{energy} = sprintf("%.4f", $effort->{energy});
is_deeply( $effort, \%ok, 'leading whitespace ignored' );

# text parameter as a scalar
$effort = effort( text => $text );
$effort->{energy} = sprintf("%.4f", $effort->{energy});
is_deeply( $effort, \%ok, 'leading whitespace ignored' );

