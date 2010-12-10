package Acme::Ikamusume;
use 5.008001;
use strict;
use warnings;
our $VERSION = '0.01';
use Carp;
use Class::Trigger;
use File::ShareDir;

use Acme::Ikamusume::MAParser;
use Acme::Ikamusume::Rule;

sub new {
    my $self = bless {}, shift;
    Acme::Ikamusume::Rule->set_rules($self);
    $self;
}

sub geso {
    my ($self, $input) = @_;
    return "" unless $input;
    $self = $self->new unless ref $self;

    my $parser = Acme::Ikamusume::MAParser->new({
        userdic => File::ShareDir::dist_file('Acme-Ikamusume', 'ika.dic'),
    });
    
    my @result;
    for my $text (split /(\s+)/, $input) {
        if ($text =~ /\s/) {
            push @result, $text;
            next;
        }
        
        my @words;
        foreach (
            my $node = $parser->parse($text);
            $node;
            $node = $node->next
        ) {
            next if $node->stat =~ /[23]/; # skip MECAB_(BOS|EOS)_NODE
            push @words, $node->surface;
            $self->call_trigger(node => ($node, \@words));
        }
        
        push @result, @words;
    }

    join "", @result;
}

1;
__END__

=encoding utf-8

=head1 NAME

Acme::Ikamusume -

=head1 SYNOPSIS

  use Acme::Ikamusume;

=head1 DESCRIPTION

Acme::Ikamusume is

=head1 METHODS

=over 4

=item new

=item foo

=back

=head1 SEE ALSO

L<Acme::Ikamusume>

=head1 AUTHOR

Naoki Tomita E<lt>tomita@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
