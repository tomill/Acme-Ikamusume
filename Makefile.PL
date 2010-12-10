use inc::Module::Install;
all_from 'lib/Acme/Ikamusume.pm';

requires 'Carp';
requires 'Class::Trigger';
requires 'Encode';
requires 'Lingua::JA::Kana';
requires 'Text::MeCab';

test_requires 'Test::More' => 0.94; # subtest
use_test_base;

author_tests 'xt';

readme_from 'lib/Acme/Ikamusume.pm';
resources(
    repository => 'http://github.com/tomi-ru/Acme-Ikamusume',
    bugtracker => 'http://github.com/tomi-ru/Acme-Ikamusume/issues',
);

WriteAll;
