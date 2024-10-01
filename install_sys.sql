--
-- Create the DBOPS schema and give the required grants
create user dbops identified by &1;
grant connect, resource to dbops;
grant administer database trigger to dbops;
grant select on dba_objects to dbops;
alter user dbops quota 100M on users;

-- APEX workspace
declare
    l_workspace_id number;
begin
  select workspace_id
  into l_workspace_id
  from apex_workspaces
  where workspace = 'DBOPS';

exception
  when no_data_found then
    APEX_INSTANCE_ADMIN.ADD_WORKSPACE(
     p_workspace           => 'DBOPS',
      p_source_identifier   => 'dbops',
      p_primary_schema     => 'DBOPS');

    l_workspace_id:= apex_util.find_security_group_id (p_workspace=>'DBOPS');
    apex_util.set_security_group_id(p_security_group_id => l_workspace_id);

    APEX_UTIL.CREATE_USER(
            p_user_name                     => 'DBOPS',
            p_web_password                  => '&1',
            p_description                   => 'DBOPS Admin user',
            p_developer_privs               => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
            p_default_schema                => 'DBOPS',
            p_allow_access_to_schemas       => 'DBOPS',
            p_change_password_on_first_use  => 'Y');      

    commit;
end;
/