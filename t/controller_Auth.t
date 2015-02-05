use strict;
use warnings;
use Test::More;
use Test::WWW::Mechanize::Catalyst;
use utf8;

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'Helena');

$mech->get_ok('/');

ok $mech->status == 200, 'Status is 200 at /';
$mech->content_contains('Login');
$mech->content_contains('<form');

$mech->submit_form(fields => { username => 'admin@exemplo.comq',
                               password => 'senha' });

ok $mech->status == 200, 'Status is 200 posting login form';
$mech->content_contains('incorret');

$mech->submit_form(fields => { username => 'admin@exemplo.com',
                               password => 'senha' });

ok $mech->status == 200, 'Status is 200 posting login form';
$mech->content_contains('Início');

$mech->get_ok('/sair');
$mech->content_contains('Login');

done_testing();
