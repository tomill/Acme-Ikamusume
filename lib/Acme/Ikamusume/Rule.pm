package Acme::Ikamusume::Rule;
use strict;
use warnings;
use utf8;
use Carp;
use Lingua::JA::Kana;

sub set_rules {
    my ($self, $translator) = @_;
    my @rules = $self->rules;
    while (my ($trigger, $code) = splice(@rules, 0, 2)) {
        $translator->add_trigger(
            name      => $trigger,
            callback  => $code,
            abortable => 1,
        );
    }
}

use constant NEXT => 1;     # for trigger control
use constant LAST => undef; # ditto
use constant CURR => -1;    # for array accessor
use constant PREV => -2;    # ditto

sub rules {
    
    # debug
    'node' => sub {
        my ($self, $node, $words) = @_;
        return NEXT unless $ENV{DEBUG};
        use YAML;
        warn Dump [ $node->surface, $node->features ];
    },
    
    # readable only
    'node' => sub {
        my ($self, $node, $words) = @_;
        if (not $node->features->{yomikana} or $node->features->{pos} eq '記号') {
            LAST;
        } else {
            NEXT;
        }
    },

    # IKA: replace
    'node' => sub {
        my ($self, $node, $words) = @_;
        my $curr = katakana2hiragana($node->features->{yomikana});
        my $next = katakana2hiragana($node->next->features->{yomikana} || "");
        my $prev = katakana2hiragana($node->prev->features->{yomikana} || "");
        
        $words->[CURR] = $curr if $curr =~ s/いか/イカ/g;
        $words->[CURR] = $curr if $curr =~ s/い$/イ/ && $next =~ /^か/;
        $words->[CURR] = $curr if $prev =~ /い$/ && $curr =~ s/^か/カ/;
        
        NEXT;
    },
    
    # GESO: eos
    'node' => sub {
        my ($self, $node, $words) = @_;
        if ($node->next->features->{pos} eq '記号' and
            $node->next->features->{category1} =~ /一般|句点/) {
            return if join('', @$words) =~ /(?:ゲソ|イカ).{0,5}$/;
            push @$words, 'でゲソ';
        }

        NEXT;
    },

}

1;
__END__

=head1 NAME

Acme::Ikamusume::Rules

=head1 SEE ALSO

L<Acme::Ikamusume>

=head1 AUTHOR

Naoki Tomita E<lt>tomita@cpan.orgE<gt>

=cut
