requires 'perl', '5.010001';

requires 'Text::Mecabist';

requires 'Encode';
requires 'File::ShareDir';
requires 'Lingua::JA::Kana';

on test => sub {
    requires 'Test::More';
    requires 'Test::Base';
};
