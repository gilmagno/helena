package Helena::View::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
    WRAPPER => 'wrapper.tt',
    ENCODING => 'utf-8',
);

=head1 NAME

Helena::View::TT - TT View for Helena

=head1 DESCRIPTION

TT View for Helena.

=head1 SEE ALSO

L<Helena>

=head1 AUTHOR

sgrs,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
