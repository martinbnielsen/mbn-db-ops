create or replace package body dbops_lock_pkg is

  cursor c_lock (
    p_schema_name in dbops_locks.owner%TYPE, 
    p_object_type in dbops_locks.object_type%TYPE, 
    p_object_name in dbops_locks.object_name%TYPE
  ) is
    select *
    from dbops_locks
    where owner = p_schema_name
    and object_type = p_object_type
    and object_name = p_object_name;

  function get_user return varchar2 is
    l_user dbops_locks.locked_by%type;
  begin
    l_user := coalesce(sys_context('APEX$SESSION','APP_USER'),user);
    return l_user;
  end get_user;


  procedure lock_object(
    p_schema_name in dbops_locks.owner%TYPE, 
    p_object_type in dbops_locks.object_type%TYPE, 
    p_object_name in dbops_locks.object_name%TYPE
  ) is
    l_user dbops_locks.locked_by%type := get_user();
    l_locked_rec c_lock%rowtype;
  begin
    -- Check for existing locks
    open c_lock(p_schema_name, p_object_type, p_object_name);
    fetch c_lock into l_locked_rec;
    close c_lock;

    if l_locked_rec.locked_by is not null then
      raise_application_error(-20001, 'Object is already locked by ' || l_locked_rec.locked_by || ' since ' || l_locked_rec.locked_on);
    end if;

    -- Create the lock
    insert into dbops_locks (owner, object_type, object_name, locked_by, locked_on)
    values (p_schema_name, p_object_type, p_object_name, get_user, localtimestamp);

  exception
      when others then
          dbms_output.put_line('error locking object: ' || sqlerrm);
  end lock_object;

  procedure release_object(
    p_schema_name in dbops_locks.owner%TYPE, 
    p_object_type in dbops_locks.object_type%TYPE, 
    p_object_name in dbops_locks.object_name%TYPE
  ) is
    l_user dbops_locks.locked_by%type := get_user();
    l_locked_rec c_lock%rowtype;
  begin
    open c_lock(p_schema_name, p_object_type, p_object_name);
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

  exception
      when others then
          dbms_output.put_line('error releasing lock: ' || sqlerrm);
  end release_object;

end dbops_lock_pkg;
/