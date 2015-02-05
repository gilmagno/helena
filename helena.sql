create table classes (
       name varchar primary key
);

create table users (
       email varchar primary key,
       password varchar,
       name varchar,
       student_number varchar,
       class_id varchar references classes,
       phone varchar,
       phone2 varchar,
       phone3 varchar,
       active boolean default 'false',
       created timestamptz,
       updated timestamptz
);

create table roles (
       id serial primary key,
       name varchar
);

create table users_roles (
       user_email varchar references users,
       role_id int references roles,
       primary key (user_email, role_id)
);

create table people (
       id serial primary key,
       name varchar,
       mother varchar,
       father varchar,
       cnpjf varchar,
       rg varchar,
       email varchar,
       address text,
       address2 text,
       phone varchar,
       phone2 varchar,
       phone3 varchar,
       comment text,
       created timestamptz,
       updated timestamptz
);

create table process_types (
       id serial primary key,
       name varchar
);

create table processes (
       id serial primary key,
       description text,
       judicial_process_number varchar,
       process_type_id int references process_types,
       register_id varchar references users,
       class_id varchar references classes,
       status varchar, -- concluído?
       active boolean,
       created timestamptz,
       updated timestamptz
);

create table process_files (
       process_id int references processes,
       uuid varchar primary key,
       filename varchar,
       size numeric,
       type varchar,
       charset varchar,
       created timestamptz
);

create table processes_plaintiffs (
       plaintiff_id int references people,
       plaintiff_process_id int references processes,
       primary key (plaintiff_id, plaintiff_process_id)
);

create table processes_representants (
       representant_id int references people,
       representant_process_id int references processes,
       primary key (representant_id, representant_process_id)
);

create table processes_defendants (
       defendant_id int references people,
       defendant_process_id int references processes,
       primary key (defendant_id, defendant_process_id)
);

create table processes_keepers (
       kept_process_id int references processes,
       keeper_id varchar references users,
       primary key (kept_process_id, keeper_id)
);

create table process_comments (
       id serial primary key,
       process_id int references processes,
       body text,
       register_id varchar references users,
       created timestamptz,
       updated timestamptz
);

-- create table process_files (
--        process_id int references processes,
--        name varchar,
--        mime varchar
-- );

-- create table process_comment_files (
--        comment_id int references process_comments,
--        name varchar,
--        mime varchar
-- );
