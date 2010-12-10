package Acme::Ikamusume::MAParser;
use strict;
use warnings;
use Encode;

use base 'Text::MeCab';

my $encoding = Encode::find_encoding( Text::MeCab::ENCODING );

sub parse {
    shift->SUPER::parse($encoding->encode(@_));
}

package Text::MeCab::Node;

{
    no strict 'refs';
    no warnings 'redefine';
    for my $method (qw( surface feature )) {
        my $original = \&$method;
        *{$method} = sub {
            $encoding->decode($original->(@_));
        };
    }
}

sub features {
    my %f; @f{qw(
        pos category1 category2 category3
        inflect inflect_type original yomikana pronounse
        extra extra2 extra3
    )} = split /,/, shift->feature;
    \%f;
};

1;
__END__

=head1 NAME

Acme::Ikamusume::MAParser

=head1 CAVEAT

Note: This module invades L<Text::MeCab> globally.

=cut
