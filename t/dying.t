# Does effort die in appropriate circumstances?

use Test::More;
plan tests => 3;

BEGIN{ use_ok('Text::Effort', 'effort') }

eval {
    effort();
}
ok( !$@, 'effort without params dies' );

eval {
    effort( layout => 'qwerty' );
}
ok( !$@, 'effort without text|file dies' );
