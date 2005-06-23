# Does effort die in appropriate circumstances?

use Test::More;
plan tests => 2;

BEGIN{ use_ok('Text::TypingEffort', 'effort') }

eval {
    effort();
};
ok( !$@, 'effort without params dies' );

eval {
    effort( layout => 'qwerty' );
};
ok( !$@, 'effort without text|file dies' );
