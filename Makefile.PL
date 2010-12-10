use inc::Module::Install;
all_from 'lib/Acme/Ikamusume.pm';

requires 'Carp';
requires 'Class::Trigger';
requires 'Encode';
requires 'File::ShareDir';
requires 'Lingua::JA::Kana';
requires 'Text::MeCab';

test_requires 'Test::More' => 0.94; # subtest
use_test_base;

eval { rebuild_userdic() }
    or warn "Can't rebuild userdic. just use userdic(utf-8) in the dist.";

sub rebuild_userdic { # okay, this is not perfect.
    require Text::MeCab;
    chomp(my $libexecdir = qx(mecab-config --libexecdir));
    chomp(my $dicdir     = qx(mecab-config --dicdir));
    my @cmd = (
        "$libexecdir/mecab-dict-index",
            '-d' => "$dicdir/ipadic",
            '-f' => 'utf-8',
            '-t' => Text::MeCab::ENCODING(),
            '-u' => 'share/ika.dic',
            'dat/ika.csv',
    );
    !system(@cmd);
}

install_share;

author_tests 'xt';

readme_from 'lib/Acme/Ikamusume.pm';
resources(
    repository => 'http://github.com/tomi-ru/Acme-Ikamusume',
    bugtracker => 'http://github.com/tomi-ru/Acme-Ikamusume/issues',
);

WriteAll;
