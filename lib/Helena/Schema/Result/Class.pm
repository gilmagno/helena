use utf8;
package Helena::Schema::Result::Class;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("TimeStamp", "PassphraseColumn");
__PACKAGE__->table("classes");
__PACKAGE__->add_columns(
  "name",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
);
__PACKAGE__->set_primary_key("name");
__PACKAGE__->has_many(
  "processes",
  "Helena::Schema::Result::Process",
  { "foreign.class_id" => "self.name" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "users",
  "Helena::Schema::Result::User",
  { "foreign.class_id" => "self.name" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-01-31 14:06:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:j4z1g5k9ImBWY99rvMlIMg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
