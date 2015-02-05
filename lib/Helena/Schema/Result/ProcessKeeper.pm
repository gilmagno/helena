use utf8;
package Helena::Schema::Result::ProcessKeeper;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("TimeStamp", "PassphraseColumn");
__PACKAGE__->table("processes_keepers");
__PACKAGE__->add_columns(
  "kept_process_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "keeper_id",
  {
    data_type      => "text",
    is_foreign_key => 1,
    is_nullable    => 0,
    original       => { data_type => "varchar" },
  },
);
__PACKAGE__->set_primary_key("kept_process_id", "keeper_id");
__PACKAGE__->belongs_to(
  "keeper",
  "Helena::Schema::Result::User",
  { email => "keeper_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "kept_process",
  "Helena::Schema::Result::Process",
  { id => "kept_process_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-01-31 14:06:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eb6rENUU8VBvdnLNn8urTw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
