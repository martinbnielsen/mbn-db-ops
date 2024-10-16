create or replace procedure dbops_admin_release_object(
    p_object_type in dbops_locks.object_type%TYPE, 
    p_object_name in dbops_locks.object_name%TYPE,
    p_owner       in dbops_locks.owner%TYPE default sys_context('USERENV', 'CURRENT_SCHEMA') 
  ) is
    l_locked_rec dbops_lock_pkg.c_lock%rowtype;
    pragma autonomous_transaction;
  begin
    open dbops_lock_pkg.c_lock(p_owner, p_object_type, p_object_name);
    fetch dbops_lock_pkg.c_lock into l_locked_rec;
    close dbops_lock_pkg.c_lock;

    delete dbops_locks
    where id = l_locked_rec.id;

    commit;
  end dbops_admin_release_object;