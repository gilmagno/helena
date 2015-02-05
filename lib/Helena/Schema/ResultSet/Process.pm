package Helena::Schema::ResultSet::Process;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

# Receives: $page, \%criteria
# Returns: \@processes, $pager
sub search_index {
    my ($self, $page, $criteria) = @_;

    my $rs = $self->search_rs(
        $criteria,
        { prefetch => [ 'process_type',
                        { 'processes_plaintiffs' => 'plaintiff' },
                        { 'processes_defendants' => 'defendant' } ],
          order_by => { -desc => 'me.id' },
          page     => $page }
    );

    return [$rs->all], $rs->pager;
}

1;
