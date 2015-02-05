use utf8;
package Helena::Schema::Result::ProcessPlaintiff;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("TimeStamp", "PassphraseColumn");
__PACKAGE__->table("processes_plaintiffs");
__PACKAGE__->add_columns(
  "plaintiff_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "plaintiff_process_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("plaintiff_id", "plaintiff_process_id");
__PACKAGE__->belongs_to(
  "plaintiff",
  "Helena::Schema::Result::Person",
  { id => "plaintiff_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "plaintiff_process",
  "Helena::Schema::Result::Process",
  { id => "plaintiff_process_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-01-31 14:06:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0+xa0QkGzlRG+AgUSA/02w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
