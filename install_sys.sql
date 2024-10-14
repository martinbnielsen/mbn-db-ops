--
-- Create the DBOPS schema and give the required grants
create user dbops identified by &1 default tablespace users;
grant connect, resource to dbops;
grant administer database trigger to dbops;
grant select on dba_objects to dbops;
grant select on dba_users to dbops;
grant create public synonym to dbops;
alter user dbops quota 100M on users;

exit;