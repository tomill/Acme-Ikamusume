package Acme::Ikamusume::MAParser;
use strict;
use warnings;
use Encode;

use base 'Text::MeCab';

my $encoding = Encode::find_encoding( Text::MeCab::ENCODING );

sub parse {
    shift->SUPER::parse($encoding->encode(@_));
}

package    # hide from the PAUSE indexer
  Text::MeCab::Node;

{
    no strict 'refs';
    no warnings 'redefine';
    for my $method (qw( surface feature )) {
        my $original = \&$method;
        *{$method} = sub {
            my $val = $original->(@_);
            defined $val ? $encoding->decode($val) : "";
        };
    }
}

sub features {
    my %f;
    
    @f{qw(
        pos category1 category2 category3
        inflect inflect_type original yomi pronounse
        extra
    )} = split(/,/, shift->feature, 10);
    
    $f{extra} = [ split /,/, $f{extra} || "" ];
    
    \%f;
};

1;
__END__

=head1 NAME

Acme::Ikamusume::MAParser

=head1 CAVEAT

Note: This module invades L<Text::MeCab> globally.

=cut
