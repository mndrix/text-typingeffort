#1
my $file = qr/ ^  (??{$hunk})*  $ /x;

#2
my $target = <>;
chomp $target;
$text =~ m/ (?:\Q$target\E)* /x;

#3
@cmd = ('get','put','try','find','copy','fold','spindle','mutilate');
$cmd = join '|', map { quotemeta $_ } @cmd;
$str =~ / (?:$cmd) \( .*? \) /;

#4
s/(\w+)/ get_val_for($1) /e;

#5
m/ [A-Za-z] [0-9]+ /x;
/ [^A-Za-z]+ /x;

#6
local $/; my $text = <>;
print "Valid diff" if $text =~ /$file/;

#7
$str =~ m{ /\* .*? \*/ }xs;

#8
$ident =~ s/^(?:\w*::)*//;

#9
warn "Thar she blows!: $&" if $str =~ m/.{81,}/;

#10
$str =~ m/ ^ m* (?:d?c{0,3}|c[dm]) (?:l?x{0,3}|x[lc]) (?:v?i{0,3}|i[vx]) $ /ix;

#11
push @lines, $1 while $str =~ m/\G([^\012\015]*)(?:\012\015?|\015\012?)/gc;

#12
$str =~ m/ " ( [^\\"]* (?: \\. [^\\"]* )* ) " /x;

#13
my $quad = qr/(?: 25[0-5] | 2[0-4]\d | [0-1]??\d{1,2} )/x;
$str =~ m/ $quad \. $quad \. $quad \. $quad /x;

#14
my $digit    = qr/[0-9]/;
my $sign_pat = qr/(?: [+-]? )/x;
my $mant_pat = qr/(?: $digit+ \.? $digit* | \. digit+ )/x;
my $expo_pat = qr/(?: $signpat $digit+ )? /x;
($sign, $mantissa, $exponent) =
    $str =~ m/ ($sign_pat) ($mant_pat) (?: e ($expo_pat) )? /x;

#15
our $parens = qr/
                   \(                   # Match a literal '('
                   (?:                  # Start a non-capturing group
                       (?>              #     Never backtrack through...
                           [^()] +      #         Match a non-paren (repeatedly)
                       )                #     End of non-backtracking region
                   |                    # Or
                       (??{$parens})    #    Recursively match entire pattern
                   )*                   # Close group and match repeatedly
                   \)                   # Match a literal ')'
                 /x;

$str =~ m/$parens/;
