create or replace package dbops_lock_pkg is

  function get_user return varchar2;
  
  function is_object_locked(
    p_owner       in dbops_locks.owner%TYPE, 
    p_object_type in dbops_locks.object_type%TYPE, 
    p_object_name in dbops_locks.object_name%TYPE
  ) return dbops_locks.locked_by%TYPE;

  procedure lock_object(
    p_owner       in dbops_locks.owner%TYPE, 
    p_object_type in dbops_locks.object_type%TYPE, 
    p_object_name in dbops_locks.object_name%TYPE
  );

  procedure release_object(
    p_owner       in dbops_locks.owner%TYPE, 
    p_object_type in dbops_locks.object_type%TYPE, 
    p_object_name in dbops_locks.object_name%TYPE
  );

end dbops_lock_pkg;
/