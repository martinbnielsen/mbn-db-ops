create or replace package dbops_lock_pkg is

  function get_user return varchar2;
  
  function is_object_locked(
    p_object_type in dbops_locks.object_type%TYPE, 
    p_object_name in dbops_locks.object_name%TYPE,
    p_owner       in dbops_locks.owner%TYPE default sys_context('USERENV', 'CURRENT_SCHEMA') 
  ) return dbops_locks.locked_by%TYPE;

  procedure lock_object(
    p_object_type in dbops_locks.object_type%TYPE, 
    p_object_name in dbops_locks.object_name%TYPE,
    p_notes       in dbops_locks.notes%TYPE default null,
    p_owner       in dbops_locks.owner%TYPE default sys_context('USERENV', 'CURRENT_SCHEMA')
  );

  procedure release_object(
    p_object_type in dbops_locks.object_type%TYPE, 
    p_object_name in dbops_locks.object_name%TYPE,
    p_owner       in dbops_locks.owner%TYPE default sys_context('USERENV', 'CURRENT_SCHEMA')     
  );

 procedure print_locks(
    p_object_type in dbops_locks.object_type%TYPE default '%', 
    p_object_name in dbops_locks.object_name%TYPE default '%',
    p_owner       in dbops_locks.owner%TYPE default sys_context('USERENV', 'CURRENT_SCHEMA') 
  );

function is_admin return varchar2;

function is_reader return varchar2;

end dbops_lock_pkg;
/