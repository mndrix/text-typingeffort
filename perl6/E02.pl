#!/usr/bin/perl
# bintree - binary tree demo program 
# adapted from "Perl Cookbook", Recipe 11.15
use strict;
use warnings;
my ($root, $n);
while ($n++ < 20) { insert($root, int rand 1000) }
use constant { PRE => 0, IN => 1, POST => 2 };
print "Pre order:  "; show($root,PRE);  print "\n";
print "In order:   "; show($root,IN);   print "\n";
print "Post order: "; show($root,POST); print "\n";
for (print "Search? "; <>; print "Search? ") {
    chomp;
    if (my $node = search($root, $_)) {
        print "Found $_ at $node: $node->{VALUE}\n";
        print "(again!)\n" if $node->{FOUND} > 1;
    }
    else {
        print "No $_ in tree\n";
    }
}
exit;
#########################################
sub insert {
    unless ($_[0]) {
        my %node;
        $node{LEFT}   = undef;
        $node{RIGHT}  = undef;
        $node{VALUE}  = $_[1]; $node{FOUND} = 0;
        $_[0] = \%node;
        return;
    }
    my ($tree,$val) = @_;
    if    ($tree->{VALUE} > $val) { insert($tree->{LEFT},  $val) }
    elsif ($tree->{VALUE} < $val) { insert($tree->{RIGHT}, $val) }
    else                          { warn "dup insert of $val\n"  }
}
sub show  {
    return unless $_[0];
    show($_[0]{LEFT}, $_[1]) unless $_[1] == POST;
    show($_[0]{RIGHT},$_[1])     if $_[1] == PRE;
    print $_[0]{VALUE};
    show($_[0]{LEFT}, $_[1])     if $_[1] == POST;
    show($_[0]{RIGHT},$_[1]) unless $_[1] == PRE;
}
sub search {
    my $tree = shift;
    return unless $tree;
    return search($tree->{$_[0]<$tree->{VALUE} && "LEFT" || "RIGHT"}, $_[0])
        unless $tree->{VALUE} == $_[0];
    $tree->{FOUND}++;
    return $tree;
}
