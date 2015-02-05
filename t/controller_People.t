use strict;
use warnings;
use Test::More;
use Test::WWW::Mechanize::Catalyst;
use utf8;

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'Helena');

$mech->get('/');
$mech->submit_form_ok(
    { fields => { username => 'admin@exemplo.com',
                  password => 'senha' } },
    'Logando'
);

$mech->get_ok('/pessoas');
$mech->content_contains('Pessoas');
$mech->get_ok('/pessoas/adicionar');
$mech->content_contains('Adicionar');

my $time = time;
$mech->submit_form_ok( { fields => { name => $time } }, 'Adicionando pessoa');
$mech->content_contains($time);

my $path = $mech->uri->path;
my $person_id;
if ($path =~ m{/(\d*)$}) { $person_id = $1 }

$mech->get_ok($path . '/editar');
$mech->content_contains($time);

$mech->submit_form_ok( { fields => { name => $time + 1 } }, 'Editando pessoa');
$mech->content_contains($time + 1);

$mech->get_ok($path);
$mech->content_contains($time + 1);
$mech->content_contains('Nome');
$mech->content_contains('CPF');

#$mech->get_ok($path . '/confirmar-delecao');
#$mech->content_contains('Confirmar deleção');

#$mech->follow_link_ok({ text => 'Confirmar deleção' });
#ok($mech->uri->path eq '/pessoas', 'Redirect pró-deleção');
#$mech->content_contains('Deleção concluída', 'Flash');

done_testing();
