#1
sub Fahrenheit_to_Kelvin {
    $_[0] -= 32;
    $_[0] /= 1.8;
    $_[0] += 273.15;
}

#2
sub Fahrenheit_to_Kelvin {
    my ($temp) = @_;
    $temp -= 32;
    $temp /= 1.8;
    $temp += 273.15;
    return $temp;
}

#3
sub part {
    my ($is_sheep, @data) = @_;
    die unless ref $is_sheep eq 'Code';
    my (@sheep, @goats);
    for (@data) {
        if $is_sheep($_) { push @sheep, $_ }
        else             { push @goats, $_ }
    }
    return (\@sheep, \@goats);
}

#4
my ($cats, $chattels) = &part \&is_feline, @animals;

#5
if ($dave == 1 || $dave == 4) { print "dave is 1 or 4\n" }

#6
if( grep {$newval>$_} @oldvals ) { print "newval isn't smallest" }

#7
my $Elvis;
tie $Elvis, 'King';

#8
push @{%herd{'sheep'}}, $_;

#9
sub part {
    my ($is_sheep, $maybe_flag_or_labels, $maybe_labels, @data) = @_;
    my ($sheep, $goats);
    if ($maybe_flag_or_labels eq "labels" && ref $maybe_labels eq 'ARRAY') { 
        ($sheep, $goats) = @$maybe_labels;
    }
    elsif (ref $maybe_flag_or_labels eq 'ARRAY') {
        unshift @data, $maybe_labels;
        ($sheep, $goats) = @$maybe_flag_or_labels;
    }
    else {
        unshift @data, $maybe_flag_or_labels, $maybe_labels;
        ($sheep, $goats) = qw(sheep goats);
    }
    my $arg1_type = ref($is_sheep) || 'CLASS';
    my %herd;
    if ($arg1_type eq 'ARRAY') {
        for my $index (0..$#data) {
            my $datum = $data[$index];
            my $label = grep({$index==$_} @$is_sheep) ? $sheep : $goats;
            push @{$herd{$label}}, $datum;
        }
    }
    else {
        croak "Invalid first argument to &part"
        unless $arg1_type =~ /^(Regexp|CODE|HASH|CLASS)$/;
        for (@data) {
            if (  $arg1_type eq 'Regexp' && /$is_sheep/
                || $arg1_type eq 'CODE'   && $is_sheep->($_)
                || $arg1_type eq 'HASH'   && $is_sheep->{$_}
                || UNIVERSAL::isa($_,$is_sheep)
            ) {
                push @{$herd{$sheep}}, $_;
            }
            else {
                push @{$herd{$goats}}, $_;
            }
        }
    }
    return map {bless {key=>$_,value=>$herd{$_}},'Pair'} keys %herd;
}

#3
sub part;
