use warnings;
use strict;

use Text::TypingEffort qw( effort );
use Test::More;

my %tests = (
    'the'         => 2,
    'banana'      => 4,
    'pill'        => 0,
    'sweet'       => 0,
    "pill\non"    => 0,
    "sweet\npill" => 1,
    "!)@(#"       => 4,
    "race\n"      => 1,
);

plan tests => scalar keys %tests;
while ( my ($text, $expected) = each %tests ) {
    ( my $message = $text) =~ s/\n/\\n/g;
    cmp_ok(
        effort($text)->{hand_changes},
        '==',
        $expected,
        $message,
    );
}
