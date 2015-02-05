use strict;
use warnings;
use Helena::Model::DB;
use utf8;
my $schema = Helena::Model::DB->new;

# roles
my $roles_rs = $schema->resultset('Role');
$roles_rs->create({ name => 'admin' });

# users
my $users_rs = $schema->resultset('User');
my @email_bases = qw/admin helena glauco larissa/;

for my $email_base (@email_bases) {
    my $email = $email_base . '@exemplo.com';
    my $user = $users_rs->create({ name => ucfirst $email_base,
                                   email => $email });
    $user->password('senha');
    $user->update;

    $user->add_to_users_roles({ role_id => 1 })
      if $email =~ /^admin/;
}

# people
my $people_rs = $schema->resultset('Person');
my $people_names_str = "Rodrigo Uchôa,Lídia Walesca,Leonardo Resende,Eli Bessa,Fernando Negreiros,Isilda,Waleska,Mateus Mosca,Ricardo Wagner,Façanha,Rodrigo Fidelis,Mauro Neris,Janaína,Maikol,Cecília,Genuíno Sales,Elisângela,Vicente,Saulo,Bernardo,Álan Siqueira,Delano,Anastácio,Renata Neris,Pragmácio,Carlos Airton,Juliana Abreu";
my @people_names = split ',', $people_names_str;

#for (1..3000) {
#    push @people_names, rand;
#}

for my $name (@people_names) {
    $people_rs->create({ name => $name,
                         cnpjf => substr rand 9, -11 });
};

# process types
my $proc_types_rs = $schema->resultset('ProcessType');
my $proc_types_str = 'Ação de Alimentos, Ação de Cobrança, Rescisória';

for my $pt (split ',', $proc_types_str) {
    $proc_types_rs->create({ name => $pt });
}

# classes / turmas
my $classes_rs = $schema->resultset('Class');
my $classes_str = '2013.2,2014.1,2014.2,2015.1';
$classes_rs->create({ name => $_ }) for split ',', $classes_str;

# processes
my $proc_rs = $schema->resultset('Process');

my @people = $people_rs->all;
my @process_types = $schema->resultset('ProcessType')->all;

for my $counter (1..30) {
    my $q = int rand scalar @process_types;
    $q++;

    my $process = $proc_rs->create({ register_id => 'admin@exemplo.com',
                                     process_type_id => $q,
                                     description => rand });

    my $n1 = int rand scalar @people;
    my $n2 = int rand scalar @people;
    if ($n1 == 0) { $n1 = 1 }
    if ($n1 == @people) { $n1 = 1 }
    if ($n2 == 0) { $n2 = 1 }
    if ($n2 == @people) { $n2 = 1 }
    my $plaintiff = $people_rs->find($n1);
    my $defendant = $people_rs->find($n2);
    my $keeper    = $users_rs->find('admin@exemplo.com');

    $process->add_to_plaintiffs($plaintiff);
    $process->add_to_defendants($defendant);
    $process->add_to_keepers($keeper);
}
