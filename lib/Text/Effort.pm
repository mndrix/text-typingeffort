package Text::Effort;

use 5.006;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw( effort );
our $VERSION = '0.01';

our %basis;  # stores the basis for our calculations

=head1 NAME

Text::Effort - calculate the effort required to type a given text

=head1 SYNOPSIS

  use Text::Effort 'effort';
  
  my $effort = effort("The quick brown fox jumps over the lazy dog");

C<$effort> is a hashref something like this

  $effort = {
      characters => 43,     # the number of characters in the text
      presses    => 44,     # keys presses need to type the text
      distance   => 950,    # millimeters the fingers moved while typing
      joules     => 2.2..., # the eneregy (Joules) used while typing
  };

=head1 DESCRIPTION

The module has one subroutine which calculates how much effort was
required to type a given text.  Several metrics of effort are calculated.
These metrics are described in detail in the L<METRICS> section.

This module can be useful for determining which of two keyboard layouts is
more efficient, for making API/language design decisions, or just for fun!

=head1 FUNCTIONS

=head2 effort $TEXT

Leading whitespace on each line is ignored since a decent text editor takes
care of that.  Only characters found on a standard US-104 keyboard are tallied
in the metrics.  That means that accented characters, unicode, etc. are not
included.

=head2 effort %OPTIONS

=cut

sub effort {
    my %opts = (
        # establish the defaults
        layout => 'qwerty',

        # override the defaults with user options
        @_,
    );

    return unless defined $opts{file};

    # fill in the preliminary data structures as needed
    %basis = &_basis( $opts{layout} ) unless %basis;

    open(FILE, "<$opts{file}") or die "Couldn't open $opts{file}";

    my %sum;
    while(<FILE>) {
        chomp;
        s/^\s*//;
        s/\s*$//;

        foreach(split //) {
            $sum{characters}++;

            foreach my $metric (qw/presses distance/) {
                if( exists $basis{$metric}{$_} ) {
                    $sum{$metric} += $basis{$metric}{$_};
                } else {
                    warn "$metric for '$_' was not found\n";
                    $basis{$metric}{$_} = 0;
                }
            }
        }
    }

    close( FILE );

    $sum{distance} = 2*$sum{distance};  # initially, distance is only one-way
    $sum{joules} = (&J_per_mm*$sum{distance}) + (&J_per_click*$sum{presses});

    return \%sum;
}

=head1 METRICS

=head2 characters

The number of recognized characters in the text.  This is similar in
spirit to the Unix command C<wc -c> but will provides a result not
greater than the Unix command.  Only those characters which are encoded
in the internal keyboard layout will be counted.  That means that accented
characters, Unicode characters, control characters, etc. are not included
in this metric.

=head2 presses

The number of keys pressed when typing the text.  The value of this metric is
the value of the B<characters> metric plus the number of times the Shift key
was pressed.

=head2 distance

The distance, in millimeters, that the fingers travelled while typing
the text.  This distance includes movement required for the Shift key,
but does not include the vertical movement the finger makes as the key
descends during a press.  Perhaps a better name for this metric would
be horizontal_distance, but that's too long ;-)

The model for determining this metric is very simplistic.  It assumes
that a finger moves from its home position to the destination key and
then returns to the home position before moving on to the next key.
Of course, this is not how people actually type, but the model should
result in an upper-bound for the amount of finger movement.

=head2 joules

The number of Joules of energy required to type the text.  This metric is
the most inclusive in that it tries to accomodate the values of both the
B<presses> and the B<distance> metrics into a single metric.  However,
this metric is also the least accurate at modeling the real world.
The calculations are roughly based upon the I<The Compendium of Physical
Activities> (or rather hearsay about it's contents since I don't have
a copy).

The physical charactersistics of the keyboard are assumed to be roughly in
line with ISO 9241-4:1998, which specifies standards for such things.

=head1 SEE ALSO

Tactus Keyboard article on the mechanics and standards of
keyboard design - http://www.tactuskeyboard.com/keymech.htm

=head1 AUTHOR

Michael Hendricks, E<lt>michael@palmcluster.orgE<gt>

=head1 TODO

=over 2

=item *

Allow keyboard layouts other than QWERTY and Dvorak

=item *

Allow keyboarrds other than US-104

=item *

Add options for specifying the characteristics of the keyboard such as
key displacement and the force required to depress the keys.

=back

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Michael Hendricks

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.4 or,
at your option, any later version of Perl 5 you may have available.

=cut



############### subroutines to help with the calculations ################

sub _basis {
    my ($desired) = @_;

    my %basis;

    # get the keyboard characteristics
    my @keyboard = &us_104;

    # get the layout
    my @layout;
    if( $desired =~ /^dvorak$/i ) {
        @layout = &dvorak;
    } else {
        @layout = &qwerty;
    }

    # get some keyboard characteristics
    my($lshift,$rshift) = splice(@keyboard, 0, 2);

    # the space character is somewhat exceptional
    $basis{distance}{' '} = shift @keyboard;
    $basis{presses}{' '} = 1;

    # populate $basis{clicks} and $basis{mm}
    while( my($shift, $d) = splice(@keyboard, 0, 2) ) {
        my($lc, $uc) = splice(@layout, 0, 2);

        $basis{presses}{$lc} = 1;
        $basis{presses}{$uc} = 2;

        $basis{distance}{$lc} = $d;
        $basis{distance}{$uc} = $d + ($shift eq 'l' ? $lshift : $rshift);
    }

    return %basis;
}

# Calculate the number of Joules of energy needed to move the
# finger 1 millimeter as it reaches for a keyboard key.
#
# English and QWERTY are used in the values below because the caloric
# studies were done with a standard QWERTY keyboard and typing English text
sub J_per_mm {
    return
            502      # Joules/ hour (energy for 150lb man typing for 1 hour)
          * (1/60)   # hours / min
          * (1/40)   # min   / word (typing speed)
          * (1/4.3)  # words / char (average English word length)
          * (1/21.2);# chars / mm   (average distance when typing QWERTY)
}

# Calculate the number of Joules of energy needed to depress a single
# key on the keyboard.
#
# The energy required is the area of a triangle with sides equal
# to the key displacement in meters (.003) and the force required to
# depress the key in Newtons (.6)  These values are taken from
# ISO 9241-4:1998(E)  (indirectly since the actual source was a quote at
# http://www.tactuskeyboard.com/keymech.htm
sub J_per_click {
    return (1/2)*(.003)*(.6);
}


################ subroutines for keyboard specifications #################
sub us_104 {
    return (
        # distances the finger must move to reach the left shift,
        # right shift and space, respectively (in millimeters)
        qw{
            15 30 0
        },

        # define the `12345 row
        # the first value is the shift key one must press when trying to
        # "capitalize" the given key.  Valid options are 'r' (right shift)
        # and 'l' (left shift).
        # the second value is the distance the finger must move from its
        # home position to reach the given key.  The distance is in millimeters.
        qw{
            r 45
            r 35
            r 35
            r 35
            r 35
            r 30
            r 40
            l 35
            l 35
            l 35
            l 30
            l 30
            l 35
            l 45
        },

        # define the QWERTY row
        qw/
            r 15
            r 15
            r 15
            r 15
            r 15
            l 25
            l 15
            l 15
            l 15
            l 15
            l 15
            l 30
        /,

        # define the home row
        qw{
            r  0
            r  0
            r  0
            r  0
            r 15
            l 15
            l  0
            l  0
            l  0
            l  0
            l 15
        },

        # define the ZXCVB row
        qw{
            r 15
            r 15
            r 15
            r 15
            r 30
            l 15
            l 15
            l 15
            l 15
            l 15
        },
    );

}

################### subroutines for keyboard layouts ####################

sub qwerty {
    no warnings 'qw';  # stop warnings about the '#' and ',' characters
    return (
        # the first value is the character generated by pressing the key
        # without any modifier.  The second value is the character generated
        # when pressing the key along with the SHIFT key.
        # define the 12345 row
        qw{
            ` ~
            1 !
            2 @
            3 #
            4 $
            5 %
            6 ^
            7 &
            8 *
            9 (
            0 )
            - _
            = +
            \ |
        },

        # define the QWERTY row
        qw/
            q  Q
            w  W
            e  E
            r  R
            t  T
            y  Y
            u  U
            i  I
            o  O
            p  P
            [  {
            ]  }
        /,

        # define the home row
        qw{
            a A
            s S
            d D
            f F
            g G
            h H
            j J
            k K
            l L
            ; :
            ' "
        },

        # define the ZXCVB row
        qw{
            z Z
            x X
            c C
            v V
            b B
            n N
            m M
            , <
            . >
            / ?
        }
    );
}

sub dvorak {
    no warnings 'qw';  # stop warnings about the '#' and ',' characters
    return (
        # define the 12345 row
        qw/
            `  ~
            1  !
            2  @
            3  #
            4  $
            5  %
            6  ^
            7  &
            8  *
            9  (
            0  )
            [  {
            ]  }
            \\ |
        /,
        # define the ',.pYF row
        qw{
            ' "
            , <
            . >
            p P
            y Y
            f F
            g G
            c C
            r R
            l L
            / ?
            = +
        },
        # define the home row
        qw{
            a A
            o O
            e E
            u U
            i I
            d D
            h H
            t T
            n N
            s S
            - _
        },
        # define the ;QJKX row
        qw{
            ; :
            q Q
            j J
            k K
            x X
            b B
            m M
            w W
            v V
            z Z
        },
    );
}


1;
__END__