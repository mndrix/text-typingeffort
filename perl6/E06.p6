#1
sub Fahrenheit_to_Kelvin($temp is rw) {
    $temp -= 32;
    $temp /= 1.8;
    $temp += 273.15;
}

#2
sub Fahrenheit_to_Kelvin($temp is copy) {
    $temp -= 32;
    $temp /= 1.8;
    $temp += 273.15;
    return $temp;
}

#3
sub part (Code $is_sheep, *@data) {
    my (@sheep, @goats);
    for @data {
        if $is_sheep($_) { push @sheep, $_ }
        else             { push @goats, $_ }
    }
    return (\@sheep, \@goats);
}

#4
my ($cats, $chattels) = part &is_feline, @animals;

#5
if $dave == 1|4 { print "dave is 1 or 4\n" }

#6
if $newval > any(@oldvals) { print "newval isn't smallest" }

#7
my $Elvis is King;

#8
push %herd{'sheep'}, $_;

#9
type Selector ::= Code | Class | Rule | Hash;
macro PART_PARAMS {
    return "Str +\@labels is dim(2) = <<sheep goats>>, *\@data";
}
multi sub part (Selector $is_sheep: PART_PARAMS) returns List of Pair
{
    my ($sheep, $goats) is constant = @labels;
    my %herd = ($sheep=>[], $goats=>[]);
    for @data {
        when $is_sheep { push %herd{$sheep}, $_ }
        default        { push %herd{$goats}, $_ }
    }
    return *%herd;
}
multi sub part ( Int @sheep_indices: PART_PARAMS) returns List of Pair
{
    my ($sheep, $goats) is constant = @labels;
    my %herd = ($sheep=>[], $goats=>[]);
    for @data -> $index, $value {
        if $index == any(@sheep_indices) { push %herd{$sheep}, $value }
        else                             { push %herd{$goats}, $value }
    }
    return *%herd;
}

#3
sub part {...};
