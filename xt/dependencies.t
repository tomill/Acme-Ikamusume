use Test::More;
plan skip_all => "Test::Dependencies is not installed." unless eval { require Test::Dependencies; 1 };
Test::Dependencies->import(
    exclude => [qw( Test::Dependencies Acme::Ikamusume )],
    style => 'light',
);
ok_dependencies();
