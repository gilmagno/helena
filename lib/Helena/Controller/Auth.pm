package Helena::Controller::Auth;
use Moose;
use namespace::autoclean;
use HTML::FormFu;

BEGIN { extends 'Catalyst::Controller'; }

sub login :Path('/entrar') Args(0) {
    my ( $self, $c ) = @_;
    my $form = HTML::FormFu->new
      ({ load_config_file => 'root/forms/auth/login_form.pl' });
    $form->process($c->req->params);

    if ($form->submitted_and_valid) {
        my $username = $form->params->{'username'};
        my $password = $form->params->{'password'};
        my $user = $c->authenticate({ email => $username,
                                      password => $password });

        if ($user) {
            return $c->res->redirect('/');
        }
        else {
            $c->flash->{error_msg} = 'Login e/ou senha incorreto/s.';
            $c->res->redirect($c->uri_for_action('/auth/login'));
            $c->detach;
        }
    }

    $c->stash(form => $form);
}

sub logout :Path('/sair') Args(0) {
    my ( $self, $c ) = @_;
    $c->logout;
    $c->res->redirect($c->uri_for_action('/auth/login'));
}

__PACKAGE__->meta->make_immutable;

1;
