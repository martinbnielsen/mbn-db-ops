create or replace package body dbops_lock_pkg is


  /**
  * Fetch current user from APEX or database session
  *
  * @return Current authenticated user
  *
  * @example select dbops_lock_pkg.get_user from dual;
  */
  function get_user return varchar2 is
    l_user dbops_locks.locked_by%type;
  begin
    l_user := coalesce(sys_context('APEX$SESSION','APP_USER'),sys_context('USERENV','OS_USER'), user);
    return upper(l_user);
  end get_user;


/**
* Check if an object is locked
*
* @param p_object_type  Object type (PACKAGE, PACKAGE BODY, TABLE, VIEW, etc)
* @param p_object_name  Name of the object
* @param p_owner        Owner of the object (defaults to current schema) 
* @return NULL if object is not locked, otherwise the user who locked it
*
* @example select dbops_lock_pkg.is_object_locked('PROCEDURE', 'MY_PROCEDURE') from dual;
*/
  function is_object_locked(
    p_object_type in dbops_locks.object_type%TYPE, 
    p_object_name in dbops_locks.object_name%TYPE,
    p_owner       in dbops_locks.owner%TYPE default sys_context('USERENV', 'CURRENT_SCHEMA') 
  ) return dbops_locks.locked_by%TYPE is
    l_locked_rec c_lock%rowtype;
  begin
    open c_lock(p_owner, p_object_type, p_object_name);
    fetch c_lock into l_locked_rec;
    close c_lock;

    if l_locked_rec.locked_by is not null then
      return l_locked_rec.locked_by;
    else
      return null;
    end if;
  end is_object_locked;



  /**
  * Lock a database object
  *
  * @param p_object_type  Object type (PACKAGE, PACKAGE BODY, TABLE, VIEW, etc)
  * @param p_object_name  Name of the object
  * @param p_notes        Optional notes
  * @param p_owner        Owner of the object (defaults to current schema) 
  *
  * @throws 
  * -20000 Schema not supported
  * -20001 Object is already locked
  * -20002 Object does not exist

  * @example exec dbops_lock_pkg.lock_object('PROCEDURE', 'MY_PROCEDURE', 'Testing locking');
  */
  procedure lock_object(
    p_object_type in dbops_locks.object_type%TYPE, 
    p_object_name in dbops_locks.object_name%TYPE,
    p_notes       in dbops_locks.notes%TYPE default null,
    p_owner       in dbops_locks.owner%TYPE default sys_context('USERENV', 'CURRENT_SCHEMA')
  ) is
    l_user dbops_locks.locked_by%type := get_user();
    l_locked_rec c_lock%rowtype;
    l_found      number;
    pragma autonomous_transaction;
  begin
    -- TODO: Check if schema is supported
    select COUNT(*)
    into l_found
    from dbops_schemas
    where owner = upper(p_owner)
    and enabled_flag = 'Y';

    if l_found = 0 then
      raise_application_error(-20000, 'Schema not supported: ' || p_owner);
    end if;

    -- Check for existing locks
    open c_lock(p_owner, p_object_type, p_object_name);
    fetch c_lock into l_locked_rec;
    close c_lock;

    if l_locked_rec.locked_by is not null then
      raise_application_error(-20001, 'Object is already locked by ' || l_locked_rec.locked_by || ' since ' || l_locked_rec.locked_on);
    end if;

    -- Check if object exists
    select count(*)
    into l_found
    from dba_objects
    where object_type = upper(p_object_type)
    and object_name = upper(p_object_name)
    and owner = upper(p_owner);

    if l_found = 0 then
      raise_application_error(-20002, 'Object ' || p_owner || '.' || p_object_name || ' of type ' || p_object_type || ' does not exist');
    end if;

    -- Create the lock
    insert into dbops_locks (owner, object_type, object_name, locked_by, locked_on, notes)
    values (upper(p_owner), upper(p_object_type), upper(p_object_name), get_user, localtimestamp, p_notes);

    commit;
  end lock_object;

  procedure release_object(
    p_object_type in dbops_locks.object_type%TYPE, 
    p_object_name in dbops_locks.object_name%TYPE,
    p_owner       in dbops_locks.owner%TYPE default sys_context('USERENV', 'CURRENT_SCHEMA') 
  ) is
    l_user dbops_locks.locked_by%type := get_user();
    l_locked_rec c_lock%rowtype;
    pragma autonomous_transaction;
  begin
    open c_lock(p_owner, p_object_type, p_object_name);
    fetch c_lock into l_locked_rec;
    close c_lock;

    -- TODO: Implement administrator release option
    if l_locked_rec.locked_by is null then
      raise_application_error(-20001, 'Object is not locked');
    end if;

    if l_locked_rec.locked_by != l_user then
      raise_application_error(-20001, 'Object is locked by ' || l_locked_rec.locked_by || ' and cannot be released by ' || l_user);
    end if;

    delete dbops_locks
    where id = l_locked_rec.id;

    commit;
  end release_object;



  -- Print locks only works when serverout is on
  procedure print_locks(
    p_object_type in dbops_locks.object_type%TYPE default '%', 
    p_object_name in dbops_locks.object_name%TYPE default '%',
    p_owner       in dbops_locks.owner%TYPE default sys_context('USERENV', 'CURRENT_SCHEMA') 
  ) is
  begin
    -- Set serveroutput is on
    dbms_output.put_line('DBOPS: List of locked objects');

    -- Print locks to dbms_output
    for l_rec in (
      select *
      from dbops_locks
      where owner = upper(p_owner)
      and object_type like upper(p_object_type)
      and object_name like upper(p_object_name)
    ) loop
      dbms_output.put_line(l_rec.owner || '.' ||  l_rec.object_name || ' (' || l_rec.object_type || '), Locked By: ' || l_rec.locked_by || ', On: ' || l_rec.locked_on ||
        case when l_rec.notes is not null then ', ' || l_rec.notes else null end);
    end loop;
  end;



  function is_admin return varchar2 is
  begin
    if apex_acl.has_user_role (p_role_static_id  => 'ADMINISTRATOR' ) then
      return('Y');
    else
      return('N');
    end if;
  end;


  function is_reader return varchar2 is
  begin
    if apex_acl.has_user_role (p_role_static_id  => 'READER' ) then
      return('Y');
    else
      return('N');
    end if;
  end;

end dbops_lock_pkg;
/