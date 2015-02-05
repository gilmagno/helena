use utf8;
package Helena::Schema::Result::Process;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("TimeStamp", "PassphraseColumn");
__PACKAGE__->table("processes");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "processes_id_seq",
  },
  "description",
  { data_type => "text", is_nullable => 1 },
  "judicial_process_number",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "process_type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "register_id",
  {
    data_type      => "text",
    is_foreign_key => 1,
    is_nullable    => 1,
    original       => { data_type => "varchar" },
  },
  "class_id",
  {
    data_type      => "text",
    is_foreign_key => 1,
    is_nullable    => 1,
    original       => { data_type => "varchar" },
  },
  "status",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "active",
  { data_type => "boolean", is_nullable => 1 },
  "created",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "updated",
  { data_type => "timestamp with time zone", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "class",
  "Helena::Schema::Result::Class",
  { name => "class_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);
__PACKAGE__->has_many(
  "process_comments",
  "Helena::Schema::Result::ProcessComment",
  { "foreign.process_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "process_files",
  "Helena::Schema::Result::ProcessFile",
  { "foreign.process_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "process_type",
  "Helena::Schema::Result::ProcessType",
  { id => "process_type_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);
__PACKAGE__->has_many(
  "processes_defendants",
  "Helena::Schema::Result::ProcessDefendant",
  { "foreign.defendant_process_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "processes_keepers",
  "Helena::Schema::Result::ProcessKeeper",
  { "foreign.kept_process_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "processes_plaintiffs",
  "Helena::Schema::Result::ProcessPlaintiff",
  { "foreign.plaintiff_process_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "processes_representants",
  "Helena::Schema::Result::ProcessesRepresentant",
  { "foreign.representant_process_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "register",
  "Helena::Schema::Result::User",
  { email => "register_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);
__PACKAGE__->many_to_many("defendants", "processes_defendants", "defendant");
__PACKAGE__->many_to_many("keepers", "processes_keepers", "keeper");
__PACKAGE__->many_to_many("plaintiffs", "processes_plaintiffs", "plaintiff");
__PACKAGE__->many_to_many("representants", "processes_representants", "representant");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-01-31 14:06:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ItYiCAZCrwW1pn/HAtxLyQ

__PACKAGE__->add_columns(
    '+created' => { set_on_create => 1 },
    '+updated' => { set_on_create => 1, set_on_update => 1 },
);

sub plaintiffs_names { map { $_->name } $_[0]->plaintiffs }

sub representants_names { map { $_->name } $_[0]->representants }

sub defendants_names { map { $_->name } $_[0]->defendants }

sub keepers_names { map { $_->name } $_[0]->keepers }

sub active_str { $_[0]->active ? 'Ativo' : 'Inativo' }

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
