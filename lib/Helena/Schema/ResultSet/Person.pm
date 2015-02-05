package Helena::Schema::ResultSet::Person;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

# Receives: $page, \%criteria
# Returns: \@processes, $pager
sub search_index {
    my ($self, $page, $criteria) = @_;

    my $rs = $self->search_rs(
        $criteria,
        { order_by => { -asc => 'me.name' },
          page     => $page }
    );

    return [$rs->all], $rs->pager;
}

1;
