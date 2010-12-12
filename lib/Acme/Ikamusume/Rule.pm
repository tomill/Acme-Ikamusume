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

our @EBI_ACCENT = qw(！！   ！   ♪ ♪   ♪♪);

sub rules {
    
#     # debug
#     'node' => sub {
#         my ($self, $node, $words) = @_;
#         return NEXT unless $ENV{DEBUG};
#         use YAML;
#         warn Dump [ $node->surface, $node->features ];
#     },
    
    # use userdic extra field
    'node.has_extra' => sub {
        my ($self, $node, $words) = @_;
        if (my $word = $node->features->{extra}[0]) {
            $words->[CURR] = $word;
        }
        NEXT;
    },
    
    # IKA: inflection
    'node.has_extra' => sub {
        my ($self, $node, $words) = @_;
        if (($node->features->{extra}[1] || "") eq 'inflection') {
            if ($node->prev->features->{pos} eq '名詞') {
                $words->[CURR] = 'じゃなイカ';
            }
            elsif ($node->prev->features->{pos} eq '副詞') {
                $words->[CURR] = 'でゲソか';
            }
            elsif ($node->prev->features->{pos} eq '助動詞' and
                   $node->prev->surface eq 'です') {
                $words->[PREV] = 'じゃなイ';
                $words->[CURR] = 'カ';
            }
            elsif ($node->prev->features->{inflect} =~ /五段/) {
                $words->[PREV] = _inflect_5step($words->[PREV], '.' => 'a');
                $words->[CURR] = 'なイカ';
            }
            elsif ($node->prev->features->{inflect} =~ /一段|カ変|サ変/) {
                $words->[CURR] = 'なイカ';
            }
        }
        NEXT;
    },
    
    # formal MASU to casual
    'node.readable' => sub {
        my ($self, $node, $words) = @_;
        if ($words->[CURR] eq 'ます' and $node->features->{pos} eq '助動詞' and
            $node->prev->features->{pos} eq '動詞') {
            $words->[PREV] = $node->prev->features->{original};
            $words->[CURR] = '';
        }
        NEXT;
    },
    
    # IKA: replace
    'node.readable' => sub {
        my ($self, $node, $words) = @_;
        return NEXT if $words->[CURR] =~ /イカ/;
        
        my $curr = katakana2hiragana($node->features->{yomi});
        my $next = katakana2hiragana($node->next->features->{yomi} || "");
        my $prev = katakana2hiragana($node->prev->features->{yomi} || "");
        
        $words->[CURR] = $curr if $curr =~ s/いか/イカ/g;
        $words->[CURR] = $curr if $curr =~ s/い$/イ/ && $next =~ /^か/;
        $words->[CURR] = $curr if $prev =~ /い$/ && $curr =~ s/^か/カ/;
        
        NEXT;
    },
    
    # IKA/GESO: DA + postp
    'node.readable' => sub {
        my ($self, $node, $words) = @_;
        if ($node->prev->surface eq 'だ' and
            $words->[PREV] eq 'でゲソ' and
            (
                $node->features->{pos} =~ /助詞|助動詞/ or
                $node->features->{category1} eq '接尾'
            )
        ) {
            my $kana = Lingua::JA::Kana::kana2romaji($words->[CURR]);
            
            if ($kana =~/^(?:ze|n[aeo]|yo|wa)/) {
                $words->[CURR] = '';
                $words->[PREV] = 'じゃなイカ';
            }
            if ($kana =~ /^zo/) {
                $words->[CURR] = '';
            }
        }
        NEXT;
    },
    'node.readable' => sub {
        my ($self, $node, $words) = @_;
        if ($node->features->{category1} eq '終助詞' and
            join("", @$words) =~ /(?:でゲソ|じゃなイカ)[よなね]$/) {
            $words->[CURR] = '';
        }
        NEXT;
    },
    
    # GESO: eos
    'node.readable' => sub {
        my ($self, $node, $words) = @_;
        if ($node->next->stat == 3 or # MECAB_EOS_NODE
            (
                $node->next->features->{pos} eq '記号' and
                $node->next->features->{category1} =~ /一般|句点|括弧閉/
            )
        ) {
            return NEXT if $node->features->{pos} =~ /^(?:その他|記号|助詞|接頭詞|接続詞|連体詞)/;
            return NEXT if join('', @$words) =~ /(?:ゲソ|イカ)$/;
            $words->[CURR] .= 'でゲソ';
        }
        NEXT;
    },
    
    # EBI: accent
    'node' => sub {
        my ($self, $node, $words) = @_;
        $words->[CURR] =~ s{(エビ|えび|海老)}{
            $1 . $EBI_ACCENT[ int rand scalar @EBI_ACCENT ];
        }e;
        NEXT;
    },

}

sub _inflect_5step {
    my ($verb, $from, $to) = @_;
    if (my ($kana) = $verb =~ /(\p{InHiragana})$/) {
        $kana = Lingua::JA::Kana::kana2romaji($kana);
        $kana =~ s/^sh/s/;
        $kana =~ s/^ch/t/;
        $kana =~ s/^ts/t/;
        $kana =~ s/$from$/$to/;
        $kana =~ s/^a$/wa/;
        $kana =~ s/ti/chi/;
        $kana =~ s/tu/tsu/;
        $kana = Lingua::JA::Kana::romaji2hiragana($kana);
    
        $verb =~ s/.$/$kana/;
    }
    $verb;
}

1;
__END__

=head1 NAME

Acme::Ikamusume::Rule

=head1 SEE ALSO

L<Acme::Ikamusume>

=head1 AUTHOR

Naoki Tomita E<lt>tomita@cpan.orgE<gt>

=cut
