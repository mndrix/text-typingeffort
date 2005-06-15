package Text::Effort;

use strict;
use warnings;

use base qw(Exporter);

our @EXPORT_OK = qw( effort );
our $VERSION = 0.01;

our( %basis );

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
