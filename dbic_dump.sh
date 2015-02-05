script/helena_create.pl \
    model DB DBIC::Schema Helena::Schema \
    create=static \
    'dbi:Pg:dbname=helena;host=localhost' 'helena' 'helena' \
    '{ pg_enable_utf8 => 1, quote_char => q{"}, loader_options => { components => [qw/TimeStamp PassphraseColumn/], generate_pod=>0, moniker_map => { users_roles => "UserRole", processes_plaintiffs => "ProcessPlaintiff", processes_defendants => "ProcessDefendant", processes_keepers => "ProcessKeeper" } } }'
