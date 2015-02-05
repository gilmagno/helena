use utf8;
package Helena::Schema::Result::ProcessesRepresentant;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("TimeStamp", "PassphraseColumn");
__PACKAGE__->table("processes_representants");
__PACKAGE__->add_columns(
  "representant_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "representant_process_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("representant_id", "representant_process_id");
__PACKAGE__->belongs_to(
  "representant",
  "Helena::Schema::Result::Person",
  { id => "representant_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "representant_process",
  "Helena::Schema::Result::Process",
  { id => "representant_process_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-01-31 14:06:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:opMxAdV8G37Z2pYG7zXaTg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
