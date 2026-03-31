create table efw_main_lift (
  main_lift_id number not null

  , name varchar2(100 char) not null

  , created_on timestamp(6) with local time zone not null
  , created_by varchar2(4000 char)
  , updated_on timestamp(6) with local time zone not null
  , updated_by varchar2(4000 char)

  , constraint efw_main_lift_pk primary key (main_lift_id)
);
create unique index efw_main_lift_name_unique_i on efw_main_lift (lower(name));

comment on table efw_main_lift is 'Primary compound lifts (e.g., Squat, Bench Press, Deadlift, Overhead Press).';
comment on column efw_main_lift.main_lift_id is 'Primary key.';
comment on column efw_main_lift.name is 'Name of the main lift.';
comment on column efw_main_lift.created_on is 'Timestamp when the record was created.';
comment on column efw_main_lift.created_by is 'User who created the record.';
comment on column efw_main_lift.updated_on is 'Timestamp when the record was last updated.';
comment on column efw_main_lift.updated_by is 'User who last updated the record.';

create or replace trigger efw_main_lift_ct
for insert or update on efw_main_lift compound trigger

  before statement is
  begin
    null;
  end before statement;

  before each row is
  begin
    if inserting then
      :new.main_lift_id := wwv_flow_id.next_val();
      :new.created_on := localtimestamp;
      :new.created_by := coalesce(sys_context('apex$session', 'app_user'), 'system');
    end if;
    :new.updated_on := localtimestamp;
    :new.updated_by := coalesce(sys_context('apex$session', 'app_user'), 'system');
  end before each row;

  after each row is
  begin
    null;
  end after each row;

  after statement is
  begin
    null;
  end after statement;

end;
/

create table efw_weakness (
  weakness_id number not null
  , main_lift_id number not null
  , name varchar2(100 char) not null

  , created_on timestamp(6) with local time zone not null
  , created_by varchar2(4000 char)
  , updated_on timestamp(6) with local time zone not null
  , updated_by varchar2(4000 char)

  , constraint efw_weakness_pk primary key (weakness_id)
  , constraint efw_weakness_main_lift_fk foreign key (main_lift_id) references efw_main_lift(main_lift_id) on delete cascade
);
create unique index efw_weakness_name_main_lift_unique_i on efw_weakness (main_lift_id, lower(name));

comment on table efw_weakness is 'Specific weaknesses within each main lift (e.g., Weak Lockout, Bottom Position, Mid-Range Sticking Point).';
comment on column efw_weakness.weakness_id is 'Primary key.';
comment on column efw_weakness.main_lift_id is 'Foreign key to main_lift table. Identifies which main lift this weakness belongs to.';
comment on column efw_weakness.name is 'Name of the weakness or sticking point.';
comment on column efw_weakness.created_on is 'Timestamp when the record was created.';
comment on column efw_weakness.created_by is 'User who created the record.';
comment on column efw_weakness.updated_on is 'Timestamp when the record was last updated.';
comment on column efw_weakness.updated_by is 'User who last updated the record.';

create index efw_weakness_main_lift_i on efw_weakness(main_lift_id);

create or replace trigger efw_weakness_ct
for insert or update on efw_weakness compound trigger

  before statement is
  begin
    null;
  end before statement;

  before each row is
  begin
    if inserting then
      :new.weakness_id := wwv_flow_id.next_val();
      :new.created_on := localtimestamp;
      :new.created_by := coalesce(sys_context('apex$session', 'app_user'), 'system');
    end if;
    :new.updated_on := localtimestamp;
    :new.updated_by := coalesce(sys_context('apex$session', 'app_user'), 'system');
  end before each row;

  after each row is
  begin
    null;
  end after each row;

  after statement is
  begin
    null;
  end after statement;

end;
/

create table efw_exercise (
  exercise_id number not null
  , name varchar2(100 char) not null

  , created_on timestamp(6) with local time zone not null
  , created_by varchar2(4000 char)
  , updated_on timestamp(6) with local time zone not null
  , updated_by varchar2(4000 char)

  , constraint efw_exercise_pk primary key (exercise_id)
);
create unique index efw_exercise_name_unique_i on efw_exercise (lower(name));

comment on table efw_exercise is 'All exercises that can be used to address weaknesses in main lifts (e.g., Pause Squats, Board Press, Deficit Deadlifts).';
comment on column efw_exercise.exercise_id is 'Primary key.';
comment on column efw_exercise.name is 'Name of the exercise.';
comment on column efw_exercise.created_on is 'Timestamp when the record was created.';
comment on column efw_exercise.created_by is 'User who created the record.';
comment on column efw_exercise.updated_on is 'Timestamp when the record was last updated.';
comment on column efw_exercise.updated_by is 'User who last updated the record.';

create or replace trigger efw_exercise_ct
for insert or update on efw_exercise compound trigger

  before statement is
  begin
    null;
  end before statement;

  before each row is
  begin
    if inserting then
      :new.exercise_id := wwv_flow_id.next_val();
      :new.created_on := localtimestamp;
      :new.created_by := coalesce(sys_context('apex$session', 'app_user'), 'system');
    end if;
    :new.updated_on := localtimestamp;
    :new.updated_by := coalesce(sys_context('apex$session', 'app_user'), 'system');
  end before each row;

  after each row is
  begin
    null;
  end after each row;

  after statement is
  begin
    null;
  end after statement;

end;
/

create table efw_exercise_to_fix_weakness (
  exercise_to_fix_weakness_id number not null
  , weakness_id number not null
  , exercise_id number not null

  , created_on timestamp(6) with local time zone not null
  , created_by varchar2(4000 char)
  , updated_on timestamp(6) with local time zone not null
  , updated_by varchar2(4000 char)

  , constraint efw_exercise_to_fix_weakness_pk primary key (exercise_to_fix_weakness_id)
  , constraint efw_exercise_to_fix_weakness_weakness_fk foreign key (weakness_id) references efw_weakness(weakness_id) on delete cascade
  , constraint efw_exercise_to_fix_weakness_exercise_fk foreign key (exercise_id) references efw_exercise(exercise_id) on delete cascade
  , constraint efw_exercise_to_fix_weakness_exercise_weakness_uk unique (exercise_id, weakness_id)
);

comment on table efw_exercise_to_fix_weakness is 'Intersection table linking exercises to the weaknesses they are designed to address.';
comment on column efw_exercise_to_fix_weakness.exercise_to_fix_weakness_id is 'Primary key.';
comment on column efw_exercise_to_fix_weakness.weakness_id is 'Foreign key to weakness table.';
comment on column efw_exercise_to_fix_weakness.exercise_id is 'Foreign key to exercise table.';
comment on column efw_exercise_to_fix_weakness.created_on is 'Timestamp when the record was created.';
comment on column efw_exercise_to_fix_weakness.created_by is 'User who created the record.';
comment on column efw_exercise_to_fix_weakness.updated_on is 'Timestamp when the record was last updated.';
comment on column efw_exercise_to_fix_weakness.updated_by is 'User who last updated the record.';

create index efw_exercise_to_fix_weakness_weakness_i on efw_exercise_to_fix_weakness(weakness_id);
create index efw_exercise_to_fix_weakness_exercise_i on efw_exercise_to_fix_weakness(exercise_id);

create or replace trigger efw_exercise_to_fix_weakness_ct
for insert or update on efw_exercise_to_fix_weakness compound trigger

  before statement is
  begin
    null;
  end before statement;

  before each row is
  begin
    if inserting then
      :new.exercise_to_fix_weakness_id := wwv_flow_id.next_val();
      :new.created_on := localtimestamp;
      :new.created_by := coalesce(sys_context('apex$session', 'app_user'), 'system');
    end if;
    :new.updated_on := localtimestamp;
    :new.updated_by := coalesce(sys_context('apex$session', 'app_user'), 'system');
  end before each row;

  after each row is
  begin
    null;
  end after each row;

  after statement is
  begin
    null;
  end after statement;

end;
/