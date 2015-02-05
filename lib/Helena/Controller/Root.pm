package Helena::Controller::Root;
use Moose;
use namespace::autoclean;
use utf8;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

sub auto :Private {
    my ($self, $c) = @_;

    if ($c->user_exists) { return 1 }
    else {
        return 1 if $c->req->path eq 'entrar';

        $c->res->redirect('/entrar');
        return 0;
    }
}

sub index :Path Args(0) {
    my ( $self, $c ) = @_;
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;
