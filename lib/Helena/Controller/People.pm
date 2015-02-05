package Helena::Controller::People;
use Moose;
use namespace::autoclean;
use HTML::FormFu;
use constant PERSON_FORM_FILE => 'root/forms/people/person_form.pl';
use utf8;

BEGIN { extends 'Catalyst::Controller'; }

sub base :Chained('/') PathPart('pessoas') CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash(people_rs => $c->model('DB::Person'));
}

sub object :Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $person_id) = @_;
    my $person;

    eval { $person = $c->stash->{people_rs}->find($person_id) };

    if ($@ or !$person) {
        $c->flash->{info_msg} = 'Registro não encontrado.';
        return $c->res->redirect($c->uri_for_action('/people/index'));
    }

    $c->stash(person => $person);
}

sub index :Chained('base') PathPart('') Args(0) {
    my ( $self, $c ) = @_;
    my $search_query = $c->req->params->{'q'};
    my $criteria;

    if ($search_query) {
        $search_query =~ s/<*//g;
        $criteria = { name => { ilike => '%' . $search_query . '%' } };
    }

    my ($people, $pager) = $c->stash->{people_rs}->search_index(
        $c->req->params->{pagina} || 1,
        $criteria
    );

    $c->stash(people => $people,
              pager => $pager,
              search_query => $search_query);
}

sub details :Chained('object') PathPart('') Args(0) {}

sub add :Chained('base') PathPart('adicionar') Args(0) {
    my ($self, $c) = @_;
    my $form = _get_form($c);

    if ($form->submitted_and_valid) {
        my $person = $form->model->create;
        $c->flash->{success_msg} = 'Adição concluída.';
        return $c->res->redirect($c->uri_for_action('/people/details',
                                                    [$person->id]));
    }

    $c->stash(form => $form);
}

sub edit :Chained('object') PathPart('editar') Args(0) {
    my ($self, $c) = @_;
    my $form = _get_form($c);
    my $person = $c->stash->{person};

    if ($form->submitted_and_valid) {
        $form->model->update($person);
        $c->flash->{success_msg} = 'Edição concluída.';
        return $c->res->redirect($c->uri_for_action('/people/details',
                                                    [$person->id]));
    }

    $form->model->default_values($person);
    $c->stash(form => $form);
}

#sub delete_confirmation :Chained('object') PathPart('confirmar-delecao') Args(0) {}

#sub delete :Chained('object') PathPart('deletar') Args(0) {
#    my ($self, $c) = @_;
#    $c->stash->{person}->delete;
#    $c->flash->{success_msg} = 'Deleção concluída.';
#    return $c->res->redirect($c->uri_for_action('/people/index'));
#}

sub _get_form {
    my $c = shift;
    my $form = HTML::FormFu->new({ load_config_file => PERSON_FORM_FILE });
    $form->stash->{schema} = $c->model('DB')->schema;
    $form->process($c->req->params);
    return $form;
}

sub processes :Chained('object') PathPart('processos') Args(0) {
    my ($self, $c) = @_;

    my @procs_as_plaintiff = $c->stash->{person}->plaintiff_processes
      (undef, { order_by => { -desc => 'plaintiff_process.id' },
                prefetch => [ 'process_type',
                              { processes_plaintiffs => 'plaintiff' },
                              { processes_defendants => 'defendant' } ],
            });

    my @procs_as_defendant = $c->stash->{person}->defendant_processes
      (undef, { order_by => { -desc => 'defendant_process.id' },
                prefetch => [ 'process_type',
                              { processes_plaintiffs => 'plaintiff' },
                              { processes_defendants => 'defendant' } ],
            });

    $c->stash(procs_as_plaintiff => \@procs_as_plaintiff,
              procs_as_defendant => \@procs_as_defendant);
}

__PACKAGE__->meta->make_immutable;

1;
