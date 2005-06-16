#!/usr/bin/perl

my ($x, $y, $k);
my $b = ' .:,;!/>)|&IH%*#';

my ($P, $Q, $X, $L);
my ($r, $i, $z, $Z, $t, $c, $C);
for ($L = 0;; $L++) {
    last() if $L > 0;
    for ($y=30; $P = $y * 0.1, $C = $P - 1.5, 1;) {
        last() if $y < 0;
        $y--;
        for ($x=0; $P = $x * 0.04, $c = $P - 2, $z=0.0, $Z=0.0, 1;) {
            last() if $x > 75;
            $x++;
            for (
                $r=$c, $i=$C, $k=0;
                $P = $z*$z, $Q = $Z*$Z, $P = $P-$Q, $t = $P+$r,
                $P = $z*2.0,$P = $P*$Z, $Z = $P + $i,
                $z=$t, 1; $k++
            ) {
                last() if $k > 12;
                $P = $z * $z;
                $Q = $Z * $Z;
                $P = $P + $Q;
                last() if $P > 10.0;
            }
            $P = $k % 12;
            $X = substr($b, $P, 1);
            print $X;
        }
        print "\n";
    }
}
