#1
class Point {
    has $.x;
    has $.y is rw;

    method clear () { $.x = 0; $.y = 0; }
}
my $point = Point.new(x => 2, y => 3);
$a = $point.y;
$point.y = 42;
$b = $point.x;
$point.x = -1;
$point.clear;

#2
for (@objects) {
    $_->doit('a');
}

#3
return $class.bless( {attr => "hi"} );
