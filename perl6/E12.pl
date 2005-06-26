#1
package Point;
sub new {
    my $class = shift;
    my %self  = @_;
    bless \%self, $class;
}
sub clear { $_[0]->{x}=0; $_[0]->{y}=0; }
sub y { @_>1 ? ($_[0]->{y} = $_[1]) : $_[0]->{y} }
sub x { @_>1 ? warn "Error" : $_[0]->{x} }
my $point = Point->new(x => 2, y => 3);
$a = $point->y;
$point->y(42);
$b = $point->x;
$point->x(-1);
$point->clear;

#2
for @objects {
    .doit('a');
}

#3
return bless( {attr => "hi"}, $class );
