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

-- Install application
DECLARE
  l_workspace    apex_workspaces.workspace%TYPE := 'DBOPS';  
  l_workspace_id apex_applications.workspace_id%TYPE;
  l_application_id apex_applications.application_id%TYPE;
BEGIN
  l_workspace_id := APEX_UTIL.FIND_SECURITY_GROUP_ID (p_workspace => l_workspace);
  apex_util.set_security_group_id(p_security_group_id => l_workspace_id);
  APEX_APPLICATION_INSTALL.SET_WORKSPACE(l_workspace);

  -- Check for application overwrite
  begin
    select application_id
    into l_application_id
    from apex_applications
    where workspace_id = l_workspace_id
    and alias = 'DBOPS';

    apex_application_install.set_application_id(l_application_id);
  exception
    when no_data_found then
      null; -- No existing application found, proceed with installation
  end;

  apex_application_install.set_schema('DBOPS');  
  apex_application_install.generate_offset;
END;
/

@f100_dbops.sql

--exit;