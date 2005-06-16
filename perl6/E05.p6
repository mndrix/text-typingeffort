#1
$file = rx/ ^  <$hunk>*  $ /;

#2
my $target = <>;
$text =~ m/ $target* /;

#3
@cmd = ('get','put','try','find','copy','fold','spindle','mutilate');
$str =~ / @cmd \( .*? \) /;

#4
s/(\w+)/ <{get_val_for($1)}> /;

#5
m/ <[A-Za-z]> <[0-9]>+ /;
/ <-[A-Za-z]>+ /;

#6
my $text is from($*ARGS);
print "Valid diff" if $text =~ /<$file>/;

#7
$str =~ m{ /\* .*? \*/ };

#8
$ident =~ s/^[\w*\:\:]*//;

#9
warn "Thar she blows!: $0" if $str =~ m/\N<81,>/;

#10
$str =~ m:i/ ^ m* [d?c<0,3>|c<[dm]>] [l?x<0,3>|x<[lc]>] [v?i<0,3>|i<[vx]>] $ /;

#11
push @lines, $1 while $str =~ m:c/ (\N*) \n /;

#12
$str =~ m/ " ( <-[\\"]>* [ \\. <-[\\"]>* ]* ) " /;

#13
rule quad { (\d<1,3>) :: <($1 < 256)> }
$str =~ m/ <quad> \. <quad> \. <quad> \. <quad> /x;

#14
rule sign     { <[+-]>? }
rule mantissa { <digit>+ [\. <digit>*] | \. <digit>+ }
rule exponent { [ <sign> <digit>+ ]? }
($sign, $mantissa, $exponent) = 
    $str =~ m/ (<sign>) (<mantissa>) [e (<exponent>)]? /;

#15

$str =~ m/ <'('>                # Match a literal '('
           [                    # Start a non-capturing group
                <-[()]> +       #    Match a non-paren (repeatedly)
                :               #    ...and never backtrack that match
           |                    # Or
                <self>          #    Recursively match entire pattern
           ]*                   # Close group and match repeatedly
           <')'>                # Match a literal ')'
         /;
