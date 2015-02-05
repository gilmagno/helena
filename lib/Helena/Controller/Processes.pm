package Helena::Controller::Processes;
use Moose;
use namespace::autoclean;
use HTML::FormFu;
use constant PROCESS_FORM_FILE => 'root/forms/processes/process_form.pl';
use utf8;
use UUID;

BEGIN { extends 'Catalyst::Controller'; }

sub base :Chained('/') PathPart('processos') CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash(processes_rs => $c->model('DB::Process'));
}

sub object :Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $process_id) = @_;
    my $process;

    eval { $process = $c->stash->{processes_rs}->find($process_id) };

    if ($@ or !$process) {
        $c->flash->{info_msg} = 'Registro não encontrado.';
        return $c->res->redirect($c->uri_for_action('/processes/index'));
    }

    $c->stash(process => $process);
}

sub index :Chained('base') PathPart('') Args(0) {
    my ($self, $c) = @_;
    my $search_query = $c->req->params->{'q'};
    my $criteria;

    if ($search_query) {
        $search_query =~ s/<*//g;
        $criteria = { -or => { 'plaintiff.name' => { ilike => '%' . $search_query . '%' },
                               'defendant.name' => { ilike => '%' . $search_query . '%' } } };
    }

    my ($processes, $pager) = $c->stash->{processes_rs}->search_index(
        $c->req->params->{pagina} || 1,
        $criteria
    );

    $c->stash(processes => $processes,
              pager => $pager,
              search_query => $search_query);
}

sub details :Chained('object') PathPart('') Args(0) {
    my ($self, $c) = @_;

    my @comments = $c->stash->{process}->process_comments
      (undef, { order_by => { -desc => 'created' } });

    $c->stash(comments => \@comments);
}

sub add :Chained('base') PathPart('adicionar') Args(0) {
    my ($self, $c) = @_;
    my $form = _get_form($c);

    if ($form->submitted_and_valid) {
        my $process = $c->stash->{processes_rs}->new_result({
            register_id => $c->user->email,
        });
        $form->model->update($process);
        $c->flash->{success_msg} = 'Adição concluída.';
        $c->res->redirect($c->uri_for_action('/processes/details', [$process->id]));
    }

    $c->stash(form => $form);
}

sub edit :Chained('object') PathPart('editar') Args(0) {
    my ($self, $c) = @_;
    my $form = _get_form($c);
    my $process = $c->stash->{process};

    if ($form->submitted_and_valid) {
        $form->model->update($process);
        $c->flash->{success_msg} = 'Adição concluída.';
        $c->res->redirect($c->uri_for_action('/processes/details',
                                             [$process->id]));
    }
    else {
        $form->model->default_values($process);
    }

    $c->stash(form => $form);
}

sub delete_confirmation :Chained('object') PathPart('confirmar-delecao') Args(0) {}

sub delete :Chained('object') PathPart('deletar') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{process}->delete;
    $c->flash->{success_msg} = 'Deleção concluída.';
    return $c->res->redirect($c->uri_for_action('/processes/index'));
}

sub my_processes :Path('/meus-processos') Args(0) {
    my ($self, $c) = @_;

    my $processes_rs = $c->model('DB::Process');

    my @processes = $processes_rs->search
      ({ 'keeper.email' => $c->user->email },
       { join => [ { processes_keepers => 'keeper' } ] });

    $c->stash(processes => \@processes);
}

# comments ###########################################################

sub add_comment :Chained('object') PathPart('adicionar-comentario') Args(0) {
    my ($self, $c) = @_;

    if ($c->req->method eq 'POST') {
        my $comment = { body => $c->req->params->{body},
                        register_id => $c->user->id };
        my $process = $c->stash->{process};
        $process->add_to_process_comments($comment);
        $c->res->redirect
          ($c->uri_for_action('/processes/details', [$process->id]));
    }
}

sub delete_comment :Chained('object') PathPart('deletar-comentario') Args(1) {
    my ($self, $c, $comment_id) = @_;
    $c->detach unless $c->check_user_roles('admin');

    my ($comment) = $c->stash->{process}->process_comments({ id => $comment_id });
    $comment->delete;

    $c->flash->{success_msg} = 'Comentário deletado.';
    $c->res->redirect($c->uri_for_action('/processes/details', [$c->stash->{process}->id]));
    $c->detach;
}

# processes attached files ###########################################

sub attach_file :Chained('object') PathPart('anexar-arquivo') Args(0) {
    my ($self, $c) = @_;

    if ($c->req->method eq 'POST') {
        if (my $upload = $c->req->upload('file')) {
            my $uuid = UUID::uuid;
            $upload->copy_to('root/processes_files/' . $uuid);
            $c->stash->{process}->add_to_process_files
              ({ uuid => $uuid,
                 filename => $upload->filename,
                 size => $upload->size,
                 type => $upload->type,
                 charset => $upload->charset });
        }
        $c->flash->{success_msg} = 'Arquivo anexado.';
        $c->res->redirect($c->uri_for_action('/processes/details', [$c->stash->{process}->id]));
        $c->detach;
    }
}

sub get_attached_file :Chained('object') PathPart('arquivo') Args(1) {
    my ($self, $c, $uuid) = @_;

    my ($file) = $c->stash->{process}->process_files({ uuid => $uuid });
    my $filename = $file->filename;
    $c->res->header('Content-Disposition', qq[attachment; filename="$filename"]);
    $c->res->content_type($file->type);
    open my $fh, '<', 'root/processes_files/' . $file->uuid;
    $c->res->body( $fh );
}

sub delete_attached_file :Chained('object') PathPart('deletar-arquivo') Args(1) {
    my ($self, $c, $uuid) = @_;
    $c->detach unless $c->check_user_roles('admin');

    my ($file) = $c->stash->{process}->process_files({ uuid => $uuid });
    my $filename = $file->filename;

    $file->delete;
    unlink 'root/processes_files/' . $uuid;

    $c->flash->{success_msg} = "Arquivo $filename deletado.";
    $c->res->redirect($c->uri_for_action('/processes/details', [$c->stash->{process}->id]));
    $c->detach;
}

######################################################################

sub search_people :Chained('base') PathPart('procurar-pessoas') Args(0) {
    my ($self, $c) = @_;

    my $criteria = { name => { ilike => '%' . $c->req->params->{'q'} . '%' } };
    my @people = $c->model('DB::Person')->search($criteria, { order_by => { -asc => 'name' } });

    my @people_hashes = map { { id => $_->id, text => $_->name } } @people;

    $c->stash->{json} = \@people_hashes;
    $c->forward('View::JSON');
}

sub search_users :Chained('base') PathPart('procurar-usuarios') Args(0) {
    my ($self, $c) = @_;

    my $criteria = { name => { ilike => '%' . $c->req->params->{'q'} . '%' } };
    my @users = $c->model('DB::User')->search($criteria, { order_by => { -asc => 'name' } });

    my @users_hashes = map { { id => $_->id, text => $_->name } } @users;

    $c->stash->{json} = \@users_hashes;
    $c->forward('View::JSON');
}

sub _get_form {
    my $c = shift;
    my $form = HTML::FormFu->new({ load_config_file => PROCESS_FORM_FILE });
    $form->stash->{schema} = $c->model('DB')->schema;
    $form->process($c->req->params);
    return $form;
}

1;
