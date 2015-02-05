use strict;
use warnings;
use Test::More;
use Test::WWW::Mechanize::Catalyst;

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'Helena');

$mech->get_ok('/processos');
$mech->get_ok('/processos/adicionar');

#form_submit

#my $path = $mech->path;
#$mech->get_ok($path);
#$mech->get_ok($path . '/editar');

# delete

done_testing();
